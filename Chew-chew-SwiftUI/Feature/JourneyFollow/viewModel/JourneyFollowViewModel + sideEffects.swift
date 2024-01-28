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
	func whenEditing() -> Feedback<State, Event> {
		Feedback { [weak self] (state: State) -> AnyPublisher<Event, Never> in
			guard let self = self else {
				return Just(Event.didFailToEdit(
					action: .adding,
					error: Error.inputValIsNil("self")
				)).eraseToAnyPublisher()
			}
			switch state.status {
			case .editing(let action,let ref, let viewData,let vm):
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
					guard !journeys.contains(where: {$0.journeyRef == ref}) else {
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
					vm?.send(event: .didChangedSubscribingState(isFollowed: !(vm?.state.data.isFollowed ?? false)))
					return Just(Event.didEdit(data: journeys))
						.eraseToAnyPublisher()
				case .deleting:
					guard let index = journeys.firstIndex(where: { $0.journeyRef == ref} ) else {
						return Just(Event.didFailToEdit(
							action: action,
							error: Error.notFoundInFollowList("not found in follow list to delete")
						)).eraseToAnyPublisher()
					}
					guard self.coreDataStore?.deleteJourneyIfFound(journeyRef: ref) == true else {
						return Just(Event.didFailToEdit(
							action: action,
							error: CoreDataError.failedToDelete(type: ChewJourney.self)
						)).eraseToAnyPublisher()
					}
					journeys.remove(at: index)
					vm?.send(event: .didChangedSubscribingState(isFollowed: !(vm?.state.data.isFollowed ?? false)))
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
