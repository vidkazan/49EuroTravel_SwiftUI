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
	static func whenLoadingInitialData() -> Feedback<State, Event> {
		Feedback { (state: State) -> AnyPublisher<Event, Never> in
			guard case .loadingInitialData = state.status else {
				return Empty().eraseToAnyPublisher()
			}
			guard Model.shared.coreDataStore.fetchUser() != nil else {
				print("whenLoadingInitialData: user is nil: loading default data")
				return Just(Event.didLoadInitialData(Settings()))
					.eraseToAnyPublisher()
			}
			
			let settings = Model.shared.coreDataStore.fetchSettings()

			
			Task.detached {
				if settings.onboarding == true {
					Model.shared.coreDataStore.disableOnboarding()
				}
				if let stops = Model.shared.coreDataStore.fetchLocations() {
					Model.shared.searchStopsViewModel.send(event: .didRecentStopsUpdated(recentStops: stops))
				}
				if let recentSearches = Model.shared.coreDataStore.fetchRecentSearches() {
					Model.shared.recentSearchesViewModel.send(event: .didUpdateData(recentSearches))
				}
				if let chewJourneys = Model.shared.coreDataStore.fetchJourneys() {
					let data = chewJourneys.map {$0.journeyFollowData()}
					Model.shared.journeyFollowViewModel.send(event: .didUpdateData(data))
				}
			}
			return Just(Event.didLoadInitialData(settings))
				.eraseToAnyPublisher()
		}
	}
}

