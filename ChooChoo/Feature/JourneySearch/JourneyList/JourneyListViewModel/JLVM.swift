//
//  SearchStopViewModel.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 03.09.23.
//

import Foundation
import Combine
import SwiftUI

final class JourneyListViewModel : ObservableObject {
	let id = UUID()
	@Published private(set) var state : State {
		didSet {print("[🚂] >> journeys state: ",state.status.description)}
	}
	private var bag = Set<AnyCancellable>()
	private let input = PassthroughSubject<Event,Never>()
	
	// testing init
	init(stops : DepartureArrivalPair,viewData : JourneyListViewData) {
//		print("💾 JLVM \(self.id.uuidString.suffix(4)) init")
		state = State(
			journeys: viewData.journeys,
			date: .init(date: .now, mode: .departure),
			earlierRef: nil,
			laterRef: nil,
			settings: Settings(),
			stops: stops,
			status: .journeysLoaded
		)
		Publishers.system(
			initial: state,
			reduce: Self.reduce,
			scheduler: RunLoop.main,
			feedbacks: [
				Self.userInput(input: input.eraseToAnyPublisher()),
				Self.whenLoadingJourneyRef(),
				Self.whenLoadingJourneyList()
			],
			name: "JLVM"
		)
		.assign(to: \.state, on: self)
		.store(in: &bag)
	}
	
	init(
		date: SearchStopsDate,
		settings : Settings,
		stops : DepartureArrivalPair
	) {
//		print("💾 JLVM \(self.id.uuidString.suffix(4)) init")
		state = State(
			journeys: [],
			date: date,
			earlierRef: nil,
			laterRef: nil,
			settings: settings,
			stops: stops,
			status: .loadingJourneyList
		)
		Publishers.system(
			initial: state,
			reduce: Self.reduce,
			scheduler: RunLoop.main,
			feedbacks: [
				Self.userInput(input: input.eraseToAnyPublisher()),
				Self.whenLoadingJourneyRef(),
				Self.whenLoadingJourneyList()
			],
			name: "JLVM"
		)
		.weakAssign(to: \.state, on: self)
		.store(in: &bag)
	}
	deinit {
//		print("💾🗑️ JLVM \(self.id.uuidString.suffix(4)) deinit")
		bag.removeAll()
	}
	
	func send(event: Event) {
		input.send(event)
	}
}
