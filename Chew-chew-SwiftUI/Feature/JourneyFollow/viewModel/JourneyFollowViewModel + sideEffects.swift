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
			switch state.status {
			case .editing(let action, journeyRef: let ref, let viewData,let vm):
				var journeys = state.journeys
				switch action {
				case .adding:
					guard let viewData = viewData else {
						vm?.send(event: .didFailToChangeSubscribingState)
						return Just(Event.didFailToEdit(
							action: action,
						msg: "view data is nil"
						)).eraseToAnyPublisher()
					}
					guard !journeys.contains(where: {$0.journeyRef == ref}) else {
						vm?.send(event: .didFailToChangeSubscribingState)
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
						vm?.send(event: .didFailToChangeSubscribingState)
						return Just(Event.didFailToEdit(
							action: action,
						msg: "coredata: failed to add"
						)).eraseToAnyPublisher()
					}
					journeys.append(viewData)
					vm?.send(event: .didChangedSubscribingState(isFollowed: !(vm?.state.isFollowed ?? false)))
					return Just(Event.didEdit(data: journeys))
						.eraseToAnyPublisher()
				case .deleting:
					guard
						let index = journeys.firstIndex(where: { $0.journeyRef == ref} )
					else {
						return Just(Event.didFailToEdit(action: action,msg: "not found in follow list to delete")).eraseToAnyPublisher()
					}
					guard
						self?.chewVM?.coreDataStore.deleteJourneyIfFound(journeyRef: ref) == true
					else {
						return Just(Event.didFailToEdit(action: action,msg: "not found in db to delete")).eraseToAnyPublisher()
					}
					journeys.remove(at: index)
					vm?.send(event: .didChangedSubscribingState(isFollowed: !(vm?.state.isFollowed ?? false)))
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
