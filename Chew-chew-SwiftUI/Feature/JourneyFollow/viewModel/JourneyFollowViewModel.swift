//
//  JourneyFollowViewModel.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.12.23.
//

import Foundation
import Combine

struct JourneyFollowData : Equatable {
	let journeyRef : String
	let journeyViewData : JourneyViewData?
}

final class JourneyFollowViewModel : ObservableObject, Identifiable {
	
	@Published private(set) var state : State {
		didSet {print("🔵🔵 >> follow state: ",state.status.description)}
	}
	private var bag = Set<AnyCancellable>()
	private let input = PassthroughSubject<Event,Never>()
	
	init(
		journeys : [JourneyFollowData]
	) {
		state = State(
			journeys: journeys,
			status: .idle
		)
		Publishers.system(
			initial: state,
			reduce: self.reduce,
			scheduler: RunLoop.main,
			feedbacks: [
				Self.userInput(input: input.eraseToAnyPublisher()),
				Self.whenEditing()
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

extension JourneyFollowViewModel {
	
	struct State : Equatable {
		var journeys : [JourneyFollowData]
		var status : Status
		
		init(journeys: [JourneyFollowData], status: Status) {
			self.journeys = journeys
			self.status = status
		}
	}
	
	enum Action : String {
		case adding
		case deleting
	}
	
	enum Status : Equatable {
		static func == (lhs: JourneyFollowViewModel.Status, rhs: JourneyFollowViewModel.Status) -> Bool {
			return lhs.description == rhs.description
		}
		
		case idle
		case editing(_ action: Action, journeyRef : String)
		case updating
		
		var description : String {
			switch self {
			case .idle:
				return "idle"
			case .updating:
				return "updating"
			case .editing(let action, let ref):
				return "editing \(action.rawValue) \(ref)"
			}
		}
	}
	
	enum Event {
		case didTapUpdate
		case didUpdateData([JourneyFollowData])
		
		case didTapEdit(action : Action, journeyRef : String)
		case didEdit(data : [JourneyFollowData])
		
		var description : String {
			switch self {
			case .didEdit:
				return "didEdit"
			case .didTapEdit:
				return "didTapEdit"
			case .didTapUpdate:
				return "didTapUpdate"
			case .didUpdateData:
				return "didUpdatedData"
			}
		}
	}
}


extension JourneyFollowViewModel {
	static func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
		Feedback { _ in
			return input
		}
	}
	static func whenEditing() -> Feedback<State, Event> {
		Feedback { (state: State) -> AnyPublisher<Event, Never> in
			switch state.status {
			case .editing(let action, journeyRef: let ref):
				var journeys = state.journeys
				switch action {
				case .adding:
					if journeys.first(where: { elem in
						elem.journeyRef == ref
					} ) == nil {
						journeys.append(JourneyFollowData(
							journeyRef: ref,
							journeyViewData: nil
						))
					}
					return Just(Event.didEdit(data: journeys))
						.eraseToAnyPublisher()
				case .deleting:
					if let index = journeys.firstIndex(where: { elem in
						elem.journeyRef == ref
					} ) {
						journeys.remove(at: index)
					}
					return Just(Event.didEdit(data: journeys))
						.eraseToAnyPublisher()
				}
			default:
				return Empty()
					.eraseToAnyPublisher()
			}
		}
	}
}

extension JourneyFollowViewModel {
	func reduce(_ state: State, _ event: Event) -> State {
		switch state.status {
		case .idle:
			switch event {
			case .didEdit:
				return state
			case .didTapUpdate:
				return state
			case .didUpdateData:
				return state
			case .didTapEdit(action: let action, journeyRef: let ref):
				return State(
					journeys: state.journeys,
					status: .editing(action, journeyRef: ref)
				)
			}
		case .updating:
			switch event {
			case .didTapUpdate:
				return state
			case .didUpdateData:
				return state
			case .didEdit:
				return state
			case .didTapEdit(action: let action, journeyRef: let ref):
				return State(
					journeys: state.journeys,
					status: .editing(action, journeyRef: ref)
				)
			}
		case .editing:
			switch event {
			case .didTapUpdate:
				return state
			case .didUpdateData:
				return state
			case .didTapEdit:
				return state
			case .didEdit(let data):
				return State(
					journeys: data,
					status: .idle
				)
			}
		}
	}
}
