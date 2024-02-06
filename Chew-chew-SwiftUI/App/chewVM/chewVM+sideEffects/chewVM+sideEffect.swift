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
		Feedback { [ weak self ] (state: State) -> AnyPublisher<Event, Never> in
			guard case .checkingSearchData = state.status else { return Empty().eraseToAnyPublisher() }
			guard let dep = state.depStop.stop, let arr = state.arrStop.stop else {
				return Just(Event.onNotEnoughSearchData)
					.eraseToAnyPublisher()
			}
			self?.recentSearchesViewModel.send(
				event: .didTapEdit(
					action: .adding,
					search: DepartureArrivalPair(departure: dep, arrival: arr)
				))
			return Just(Event.onJourneyDataUpdated(DepartureArrivalPair(departure: dep, arrival: arr)))
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
					print(">>>")
					let data = chewJourneys.map {$0.journeyFollowData()}
					print(">>>>")
					self.journeyFollowViewModel.send(event: .didUpdateData(data))
					print(">>>>>")
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

