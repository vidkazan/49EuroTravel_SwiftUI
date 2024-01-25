//
//  SearchStopViewModel.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 03.09.23.
//

import Foundation
import Combine
import SwiftUI

final class JourneyListViewModel : ObservableObject, Identifiable {
	var depStop : Stop
	var arrStop : Stop
	var date : ChewViewModel.ChewDate
	var settings : ChewSettings
	var followList : [String]
	@Published private(set) var state : State {
		didSet {print("[🚂] >> journeys state: ",state.status.description)}
	}
	private var bag = Set<AnyCancellable>()
	private let input = PassthroughSubject<Event,Never>()
	
	// testing init
	init(viewData : JourneyListViewData) {
		self.date = .now
		self.followList = []
		self.settings = ChewSettings()
		self.depStop = .init(coordinates: .init(), type: .stop, stopDTO: nil)
		self.arrStop = .init(coordinates: .init(), type: .stop, stopDTO: nil)
		
		state = State(
			journeys: viewData.journeys,
			earlierRef: nil,
			laterRef: nil,
			status: .journeysLoaded
		)
		Publishers.system(
			initial: state,
			reduce: self.reduce,
			scheduler: RunLoop.main,
			feedbacks: [
				Self.userInput(input: input.eraseToAnyPublisher()),
				self.whenLoadingJourneyRef(),
				self.whenLoadingJourneyList()
			]
		)
		.assign(to: \.state, on: self)
		.store(in: &bag)
	}
	
	init(
		depStop: Stop,
		arrStop: Stop,
		date: ChewViewModel.ChewDate,
		settings : ChewSettings,
		followList : [String]
	) {
		self.depStop = depStop
		self.arrStop = arrStop
		self.date = date
		self.settings = settings
		self.followList = followList
		
		state = State(
			journeys: [],
			earlierRef: nil,
			laterRef: nil,
			status: .loadingJourneyList
		)
		Publishers.system(
			initial: state,
			reduce: self.reduce,
			scheduler: RunLoop.main,
			feedbacks: [
				Self.userInput(input: input.eraseToAnyPublisher()),
				self.whenLoadingJourneyRef(),
				self.whenLoadingJourneyList()
			]
		)
		.assign(to: \.state, on: self)
		.store(in: &bag)
	}
	deinit {
		bag.removeAll()
	}
	
	func send(event: Event) {
		input.send(event)
	}
}
