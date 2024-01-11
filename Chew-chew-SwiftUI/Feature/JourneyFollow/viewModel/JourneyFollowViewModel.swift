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
	let journeyViewData : JourneyViewData
	let depStop: Stop
	let arrStop : Stop
}

final class JourneyFollowViewModel : ObservableObject, Identifiable {
	@Published private(set) var state : State {
		didSet {
			print("📌 >> state: ",state.status.description)
		}
	}
	private var bag = Set<AnyCancellable>()
	private let input = PassthroughSubject<Event,Never>()
	var chewVM : ChewViewModel?
	init(
		chewVM : ChewViewModel?,
		journeys : [JourneyFollowData]
	) {
		self.chewVM = chewVM
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
				self.whenEditing()
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
		case error(error : String)
		case idle
		case editing(_ action: Action, journeyRef : String, followData : JourneyFollowData?)
		case updating
		
		var description : String {
			switch self {
			case .error(let action):
				return "error \(action.description)"
			case .idle:
				return "idle"
			case .updating:
				return "updating"
			case .editing:
				return "editing"
			}
		}
	}
	
	enum Event {
		case didFailToEdit(action : Action, msg: String)
		case didTapUpdate
		case didUpdateData([JourneyFollowData])
		
		case didTapEdit(action : Action, journeyRef : String, followData : JourneyFollowData?)
		case didEdit(data : [JourneyFollowData])
		
		var description : String {
			switch self {
			case .didFailToEdit:
				return "didFailToEdit"
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
	func whenEditing() -> Feedback<State, Event> {
		Feedback { [weak self] (state: State) -> AnyPublisher<Event, Never> in
			switch state.status {
			case .editing(let action, journeyRef: let ref, let viewData):
				var journeys = state.journeys
				switch action {
				case .adding:
					guard let viewData = viewData else {
						return Just(Event.didFailToEdit(
							action: action,
						msg: "view data is nil"
						)).eraseToAnyPublisher()
					}
					guard !journeys.contains(where: {$0.journeyRef == ref}) else {
						return Just(Event.didFailToEdit(
							action: action,
						msg: "journey has been followed already"
						)).eraseToAnyPublisher()
					}
					guard
						self?.chewVM?.coreDataStore.addJourney(
							viewData: viewData.journeyViewData,
							depStop: viewData.depStop,
							arrStop: viewData.arrStop
						) == true
					else {
						return Just(Event.didFailToEdit(
							action: action,
						msg: "coredata: failed to add"
						)).eraseToAnyPublisher()
					}
					journeys.append(viewData)
					return Just(Event.didEdit(data: journeys))
						.eraseToAnyPublisher()
				case .deleting:
					guard
						let index = journeys.firstIndex(where: { $0.journeyRef == ref} ),
						self?.chewVM?.coreDataStore.deleteJourneyIfFound(journeyRef: ref) == true
					else {
						return Just(Event.didFailToEdit(action: action,msg: "")).eraseToAnyPublisher()
					}
					journeys.remove(at: index)
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
		print("📌🔥 > :",event.description,"state:",state.status.description)
		switch state.status {
		case .idle,.error:
			switch event {
			case .didEdit,.didFailToEdit:
				return state
			case .didTapUpdate:
				return state
			case .didUpdateData(let data):
				return State(
					journeys: data,
					status: .idle
				)
			case .didTapEdit(action: let action, journeyRef: let ref, let data):
				return State(
					journeys: state.journeys,
					status: .editing(action, journeyRef: ref,followData: data)
				)
			}
		case .updating:
			switch event {
			case .didFailToEdit:
				return state
			case .didTapUpdate:
				return state
			case .didUpdateData:
				return state
			case .didEdit:
				return state
			case .didTapEdit(action: let action, journeyRef: let ref,let data):
				return State(
					journeys: state.journeys,
					status: .editing(action, journeyRef: ref,followData: data)
				)
			}
		case .editing:
			switch event {
			case .didFailToEdit:
				return State(
					journeys: state.journeys,
					status: .idle
				)
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
