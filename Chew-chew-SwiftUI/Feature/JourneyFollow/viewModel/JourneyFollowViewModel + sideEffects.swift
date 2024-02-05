//
//  JourneyFollowViewModel.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.12.23.
//

import Foundation
import Combine

extension JourneyFollowViewModel {
	static func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
		Feedback { _ in
			return input
		}
	}
	
	func whenUpdatingJourney() -> Feedback<State, Event> {
		Feedback { [weak self] (state: State) -> AnyPublisher<Event, Never> in
			guard case let .updatingJourney(viewData, followId) = state.status else {
				return Empty().eraseToAnyPublisher()
			}
			guard let self = self else {
				return Just(Event.didFailToUpdateJourney(Error.inputValIsNil("self"))).eraseToAnyPublisher()
			}
			
			guard let oldViewData = state.journeys.first(where: {$0.id == followId}) else {
				return Just(Event.didFailToUpdateJourney(Error.notFoundInFollowList(""))).eraseToAnyPublisher()
			}
			
			guard self.coreDataStore?.updateJourney(
				   id: followId,
				   viewData: viewData,
				   depStop: oldViewData.depStop,
				   arrStop: oldViewData.arrStop) == true else {
				return Just(Event.didFailToUpdateJourney(CoreDataError.failedToUpdateDatabase(type: ChewJourney.self))).eraseToAnyPublisher()
			}
			
			var followData = state.journeys.filter({$0.id != followId})
			
			followData.append(JourneyFollowData(
				id: oldViewData.id,
				journeyViewData: viewData,
				depStop: oldViewData.depStop,
				arrStop: oldViewData.arrStop
			))
			return Just(Event.didUpdateData(followData)).eraseToAnyPublisher()
		}
	}
	func whenEditing() -> Feedback<State, Event> {
		Feedback { [weak self] (state: State) -> AnyPublisher<Event, Never> in
			guard case .editing(let action,let ref, let viewData,let vm) = state.status else {
				return Empty().eraseToAnyPublisher()
			}
			guard let self = self else {
				return Just(Event.didFailToEdit(
					action: .adding,
					error: Error.inputValIsNil("self")
				)).eraseToAnyPublisher()
			}

			var journeys = state.journeys
			switch action {
			case .adding:
				guard let viewData = viewData else {
					vm?.send(event: .didFailToChangeSubscribingState(error: Error.inputValIsNil("viewData")))
					return Just(Event.didFailToEdit(
						action: action,
						error: Error.inputValIsNil("view data is nil")
					)).eraseToAnyPublisher()
				}
				guard !journeys.contains(where: {$0.id == Int64(ref.hashValue)}) else {
					vm?.send(event: .didFailToChangeSubscribingState(
						error: Error.alreadyContains("journey has been followed already")
					))
					return Just(Event.didFailToEdit(
						action: action,
						error: Error.alreadyContains("journey has been followed already")
					)).eraseToAnyPublisher()
				}
				guard
					self.coreDataStore?.addJourney(
						id : viewData.id,
						viewData: viewData.journeyViewData,
						depStop: viewData.depStop,
						arrStop: viewData.arrStop
					) == true
				else {
					vm?.send(event: .didFailToChangeSubscribingState(
						error: CoreDataError.failedToAdd(type: ChewJourney.self)
					))
					return Just(Event.didFailToEdit(
						action: action,
						error: CoreDataError.failedToAdd(type: ChewJourney.self)
					)).eraseToAnyPublisher()
				}
				journeys.append(viewData)
				vm?.send(event: .didChangedSubscribingState)
				return Just(Event.didEdit(data: journeys))
					.eraseToAnyPublisher()
			case .deleting:
				guard let index = journeys.firstIndex(where: { $0.id == Int64(ref.hashValue)} ) else {
					return Just(Event.didFailToEdit(
						action: action,
						error: Error.notFoundInFollowList("not found in follow list to delete")
					)).eraseToAnyPublisher()
				}
				guard self.coreDataStore?.deleteJourneyIfFound(id: Int64(ref.hashValue)) == true else {
					return Just(Event.didFailToEdit(
						action: action,
						error: CoreDataError.failedToDelete(type: ChewJourney.self)
					)).eraseToAnyPublisher()
				}
				journeys.remove(at: index)
				vm?.send(event: .didChangedSubscribingState)
				return Just(Event.didEdit(data: journeys))
					.eraseToAnyPublisher()
			}
		}
	}
}
