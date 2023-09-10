//
//  SearchStopViewModel.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 03.09.23.
//

import Foundation
import Combine

final class SearchJourneyViewModel : ObservableObject, Identifiable {
	@Published var topSearchFieldText : String = ""
	@Published var bottomSearchFieldText : String = ""
	@Published private(set) var state : State {
		didSet {
			print(">> state: ",state.status.description)
		}
	}
	private var bag = Set<AnyCancellable>()
	private let input = PassthroughSubject<Event,Never>()
	
	
	init() {
		self.state = State(depStop: nil, arrStop: nil, timeChooserDate: .now, journeys: [], status: .idle)
		Publishers.system(
			initial: State(depStop: nil, arrStop: nil, timeChooserDate: .now, journeys: [], status: .idle),
			reduce: self.reduce,
			scheduler: RunLoop.main,
			feedbacks: [
				Self.userInput(input: input.eraseToAnyPublisher()),
				self.whenLoading(),
				self.whenIdleCheckForSufficientDataForJourneyRequest()
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
