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
			guard case .idle = state.status else { return Empty().eraseToAnyPublisher() }
			guard let dep = state.depStop.stop, let arr = state.arrStop.stop else { return Empty().eraseToAnyPublisher() }
			self.recentSearchesViewModel.send(
				event: .didTapEdit(
					action: .adding,
					search: DepartureArrivalPair(departure: dep, arrival: arr)
				))
			return Just(Event.onJourneyDataUpdated)
				.eraseToAnyPublisher()
		}
	}
	
	func whenLoadingInitialData() -> Feedback<State, Event> {
		Feedback { (state: State) -> AnyPublisher<Event, Never> in
			guard case .loadingInitialData = state.status else {
				return Empty().eraseToAnyPublisher()
			}
			
			guard let user = self.coreDataStore.fetchUser() else {
				print("whenLoadingInitialData: user is nil: loading default data")
				return Just(Event.didLoadInitialData(nil,ChewSettings()))
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
			}
			return Just(Event.didLoadInitialData(user,settings))
				.eraseToAnyPublisher()
		}
	}
	
	func whenEditingStops() -> Feedback<State, Event> {
		Feedback {[weak self] (state: State) -> AnyPublisher<Event, Never> in
			switch state.status {
			case .editingArrivalStop:
				self?.searchStopsViewModel.send(event: .didChangeFieldFocus(type: .arrival))
			case .editingDepartureStop:
				self?.searchStopsViewModel.send(event: .didChangeFieldFocus(type: .departure))
			default:
				break
			}
			return Empty().eraseToAnyPublisher()
		}
	}
}

