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
	weak var coreDataStore : CoreDataStore?
	init(
		coreDataStore : CoreDataStore?,
		journeys : [JourneyFollowData]
	) {
		self.coreDataStore = coreDataStore
		state = State(
			journeys: journeys,
			status: .updating
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
		case editing(_ action: Action, journeyRef : String, followData : JourneyFollowData?,journeyDetailsViewModel : JourneyDetailsViewModel?)
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
		
		case didTapEdit(
			action : Action,
			journeyRef : String,
			followData : JourneyFollowData?,
			journeyDetailsViewModel : JourneyDetailsViewModel?
		)
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
