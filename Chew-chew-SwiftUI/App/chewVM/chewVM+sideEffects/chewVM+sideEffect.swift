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
	
	func whenIdleCheckForSufficientDataForJourneyRequest() -> Feedback<State, Event> {
		Feedback { (state: State) -> AnyPublisher<Event, Never> in
			guard case .checkingSearchData = state.status else { return Empty().eraseToAnyPublisher() }
			guard let dep = state.depStop.stop, let arr = state.arrStop.stop else {
				return Just(Event.onNotEnoughSearchData)
					.eraseToAnyPublisher()
			}
			self.recentSearchesViewModel.send(
				event: .didTapEdit(
					action: .adding,
					search: DepartureArrivalPair(departure: dep, arrival: arr)
				))
			return Just(Event.onJourneyDataUpdated(depStop: dep, arrStop: arr))
				.eraseToAnyPublisher()
		}
	}
	
	func whenLoadingInitialData() -> Feedback<State, Event> {
		Feedback { [weak self] (state: State) -> AnyPublisher<Event, Never> in
			guard case .loadingInitialData = state.status else {
				return Empty().eraseToAnyPublisher()
			}
			guard let self = self else {
				return Just(Event.didLoadInitialData(ChewSettings()))
					.eraseToAnyPublisher()
			}
			guard self.coreDataStore.fetchUser() != nil else {
				print("whenLoadingInitialData: user is nil: loading default data")
				return Just(Event.didLoadInitialData(ChewSettings()))
					.eraseToAnyPublisher()
			}
			
			let settings = self.coreDataStore.fetchSettings()

			if let stops = self.coreDataStore.fetchLocations() {
				self.searchStopsViewModel.send(event: .didRecentStopsUpdated(recentStops: stops))
			}
			
			Task.detached {
				if let recentSearches = self.coreDataStore.fetchRecentSearches() {
					await self.recentSearchesViewModel.send(
						event: .didUpdateData(recentSearches)
					)
				}
				if let chewJourneys = self.coreDataStore.fetchJourneys() {
					await self.journeyFollowViewModel.send(
						event: .didUpdateData(chewJourneys.map {
							$0.journeyViewData()
						})
					)
				}
				if settings.onboarding == true {
					self.coreDataStore.disableOnboarding()
				}
			}
			return Just(Event.didLoadInitialData(settings))
				.eraseToAnyPublisher()
		}
	}
	
	func whenEditingStops() -> Feedback<State, Event> {
		Feedback {[weak self] (state: State) -> AnyPublisher<Event, Never> in
			switch state.status {
			case .editingStop(let type):
				self?.searchStopsViewModel.send(event: .didChangeFieldFocus(type: type))
			default:
				break
			}
			return Empty().eraseToAnyPublisher()
		}
	}
}

