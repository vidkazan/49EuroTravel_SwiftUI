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

			
			Task.detached {
				if settings.onboarding == true {
					self.coreDataStore.disableOnboarding()
				}
				if let stops = self.coreDataStore.fetchLocations() {
					self.searchStopsViewModel.send(event: .didRecentStopsUpdated(recentStops: stops))
				}
				if let recentSearches = self.coreDataStore.fetchRecentSearches() {
					self.recentSearchesViewModel.send(event: .didUpdateData(recentSearches))
				}
				if let chewJourneys = self.coreDataStore.fetchJourneys() {
					let data = chewJourneys.map {$0.journeyFollowData()}
					self.journeyFollowViewModel.send(event: .didUpdateData(data))
				}
			}
			return Just(Event.didLoadInitialData(settings))
				.eraseToAnyPublisher()
		}
	}
}

