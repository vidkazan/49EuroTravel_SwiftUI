//
//  SearchStopViewModel.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 03.09.23.
//

import Foundation
import Combine

final class JourneyListViewModel : ObservableObject, Identifiable {
	var depStop : StopType
	var arrStop : StopType
	var timeChooserDate : ChewViewModel.DateType
	@Published private(set) var state : State {
		didSet {
			print("🟤 >> journeys state: ",state.status.description)
		}
	}
	private var bag = Set<AnyCancellable>()
	private let input = PassthroughSubject<Event,Never>()
		
	
	init(depStop: StopType, arrStop: StopType, timeChooserDate: ChewViewModel.DateType) {
		self.depStop = depStop
		self.arrStop = arrStop
		self.timeChooserDate = timeChooserDate
		self.state = .init(journeys: [], earlierRef: nil, laterRef: nil, status: .loadingJourneys)
		Publishers.system(
			initial: .init(journeys: [], earlierRef: nil, laterRef: nil, status: .loadingJourneys),
			reduce: self.reduce,
			scheduler: RunLoop.main,
			feedbacks: [
				Self.userInput(input: input.eraseToAnyPublisher()),
				self.whenLoadingJourneyRef(),
				self.whenLoadingJourneys()
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
