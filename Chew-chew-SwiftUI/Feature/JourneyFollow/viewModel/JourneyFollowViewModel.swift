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
		journeys : [JourneyFollowData],
		initialStatus : Status = .idle
	) {
		self.coreDataStore = coreDataStore
		state = State(
			journeys: journeys,
			status: initialStatus
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
		
		var description : String {
			switch self {
			case .adding:
				return "follow"
			case .deleting:
				return "unfollow"
			}
		}
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
			case .error(let error):
				return "error \(error.description)"
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
		case didFailToEdit(action : Action, error : any ChewError)
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
			case .didFailToEdit(action: let action, error: let error):
				return "didFailToEdit: \(action): \(error)"
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
	
	enum Error : ChewError {
		static func == (lhs: Error, rhs: Error) -> Bool {
			return lhs.description == rhs.description
		}
		
		func hash(into hasher: inout Hasher) {
			switch self {
			case .inputValIsNil,
				.alreadyContains,
				.notFoundInFollowList:
				break
			}
		}
		case inputValIsNil(_ msg: String)
		case alreadyContains(_ msg: String)
		case notFoundInFollowList(_ msg: String)
		
		
		var description : String  {
			switch self {
			case .inputValIsNil(let msg):
				return "Input value is nil: \(msg)"
			case.alreadyContains(let msg):
				return "Already contains: \(msg)"
			case .notFoundInFollowList(let msg):
				return "notFoundInFollowList: \(msg)"
			}
		}
	}
}
