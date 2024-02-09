//
//  +sideEffect.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.09.23.
//

import Combine
import Foundation
import SwiftUI

extension ChewViewModel {
	static func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
		Feedback { _ in
			return input
		}
	}
	
	static func whenIdleCheckForSufficientDataForJourneyRequest() -> Feedback<State, Event> {
		Feedback {  (state: State) -> AnyPublisher<Event, Never> in
			guard case .checkingSearchData = state.status else { return Empty().eraseToAnyPublisher() }
			guard let dep = state.depStop.stop, let arr = state.arrStop.stop else {
				return Just(Event.onNotEnoughSearchData)
					.eraseToAnyPublisher()
			}
			
			Model.shared.recentSearchesViewModel.send(
				event: .didTapEdit(
					action: .adding,
					search: RecentSearchesViewModel.RecentSearch(depStop: dep, arrStop: arr,searchTS: Date.now.timeIntervalSince1970)
				))
			return Just(Event.onJourneyDataUpdated(DepartureArrivalPair(departure: dep, arrival: arr)))
				.eraseToAnyPublisher()
		}
	}	
	
	static func whenEditingStops() -> Feedback<State, Event> {
		Feedback { (state: State) -> AnyPublisher<Event, Never> in
			switch state.status {
			case .editingStop(let type):
				Model.shared.searchStopsViewModel.send(event: .didChangeFieldFocus(type: type))
			default:
				break
			}
			return Empty().eraseToAnyPublisher()
		}
	}
}

