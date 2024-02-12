//
//  MapView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 12.02.24.
//

import Foundation
import Combine

class MapViewModel : ObservableObject, Identifiable {
	@Published private(set) var state : State {
		didSet { print(">> state:",state.status.description) }
	}
	private var bag = Set<AnyCancellable>()
	private let input = PassthroughSubject<Event,Never>()
	
	
	init(_ initaialStatus : Status) {
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

extension MapViewModel {
	struct State  {
		let status : Status

		init(status: Status) {
			self.status = status
		}

	}
	
	enum Status : String {
		case journeyDetails
		case stopPicker
		var description : String {
			switch self {
			case .journeyDetails:
				return "journeyDetails"
			case .stopPicker:
				return "stopPicker"
			}
		}
	}
	
	enum Event {
		var description : String {
			return ""
		}
	}
}


extension MapViewModel {
	static func reduce(_ state: State, _ event: Event) -> State {
		print(">> ",event.description,"state:",state.status.description)
		switch state.status {
		case .journeyDetails,.stopPicker:
			return state
		}
	}
}

extension MapViewModel {
	static func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
		Feedback { _ in
			return input
		}
	}
}

