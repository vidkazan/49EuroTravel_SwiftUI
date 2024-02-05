//
//  JourneyFollowViewModel.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.12.23.
//

import Foundation
import Combine

struct JourneyFollowData : Equatable {
	let id : Int64
	let journeyViewData : JourneyViewData
	let depStop: Stop
	let arrStop : Stop
	
	init(id: Int64, journeyViewData: JourneyViewData, depStop: Stop, arrStop: Stop) {
		self.id = id
		self.journeyViewData = journeyViewData
		self.depStop = depStop
		self.arrStop = arrStop
	}
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
		initialStatus : Status = .updating
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
				self.whenEditing(),
				self.whenUpdatingJourney()
			],
			name: "JFVM"
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
		case updatingJourney(_ viewData : JourneyViewData,_ followId : Int64)
		
		var description : String {
			switch self {
			case let .updatingJourney(viewData, _):
				return "updatingJourney \(viewData.destination)"
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
		case didRequestUpdateJourney(JourneyViewData, Int64)
		case didFailToUpdateJourney(_ error : any ChewError)
		
		case didTapEdit(
			action : Action,
			journeyRef : String,
			followData : JourneyFollowData?,
			journeyDetailsViewModel : JourneyDetailsViewModel?
		)
		case didEdit(data : [JourneyFollowData])
			
		var description : String {
			switch self {
			case let .didRequestUpdateJourney(viewData, _):
				return "didRequestUpdateJourney \(viewData.origin) \(viewData.destination)"
			case .didFailToUpdateJourney(let error):
				return "didFailToUpdateJourney \(error.localizedDescription)"
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
