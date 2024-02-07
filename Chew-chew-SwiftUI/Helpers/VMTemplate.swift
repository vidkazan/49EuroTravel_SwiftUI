//
//  VMTemplate.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 23.01.24.
//

import Foundation
import Combine

class ViewModel : ObservableObject, Identifiable {
	@Published private(set) var state : State {
		didSet { print(">> state:",state.status.description) }
	}
	private var bag = Set<AnyCancellable>()
	private let input = PassthroughSubject<Event,Never>()
	
	
	init(_ initaialStatus : Status = .start) {
		self.state = State(
			status: initaialStatus
		)
		Publishers.system(
			initial: state,
			reduce: Self.reduce,
			scheduler: RunLoop.main,
			feedbacks: [
				Self.userInput(input: input.eraseToAnyPublisher()),
			],
			name: ""
		)
		.weakAssign(to: \.state, on: self)
		.store(in: &bag)
	}
	
	deinit {
		bag.removeAll()
	}

	func send(event: Event) {
		input.send(event)
	}
}

extension ViewModel : ChewViewModelProtocol {
	struct State  {
		let status : Status

		init(status: Status) {
			self.status = status
		}
	}
	
	enum Status {
		static func == (lhs: ViewModel.Status, rhs: ViewModel.Status) -> Bool {
			return lhs.description == rhs.description
		}
		case start
		
		var description : String {
			switch self {
			case .start:
				return "start"
			}
		}
	}
	
	enum Event {
		case didLoadInitialData
		
		var description : String {
			switch self {
			case .didLoadInitialData:
				return "didLoadInitialData"
			}
		}
	}
}


extension ViewModel {
	static func reduce(_ state: State, _ event: Event) -> State {
		print(">> ",event.description,"state:",state.status.description)
		switch state.status {
		case .start:
			switch event {
			case .didLoadInitialData:
				return state
			}
		}
	}
}

extension ViewModel {
	static func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
		Feedback { _ in
			return input
		}
	}
}

