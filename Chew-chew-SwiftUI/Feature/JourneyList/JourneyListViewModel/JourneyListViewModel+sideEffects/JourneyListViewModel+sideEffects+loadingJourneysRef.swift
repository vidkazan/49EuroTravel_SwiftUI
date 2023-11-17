//
//  SearchJourneyVM+feedback.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 06.09.23.
//

import Foundation
import Combine

extension JourneyListViewModel {
	func whenLoadingJourneyRef() -> Feedback<State, Event> {
		Feedback {[self] (state: State) -> AnyPublisher<Event, Never> in
			guard case .loadingRef(let type) = state.status else { return Empty().eraseToAnyPublisher() }
			switch type {
			case .initial:
				return  Empty().eraseToAnyPublisher()
			case .earlierRef:
				guard let ref = state.earlierRef else {
					print("🟤❌ >> earlierRef is nil")
					return Just(Event.didFailToLoadEarlierRef(.badUrl)).eraseToAnyPublisher()
				}
				return self.fetchEarlierOrLaterRef(dep: depStop, arr: arrStop, ref: ref, type: type,settings: self.settings)
					.mapError{ $0 }
					.asyncFlatMap { data in
						let res = await constructJourneysViewDataAsync(journeysData: data, depStop: self.depStop, arrStop: self.arrStop)
						return Event.onNewJourneysData(JourneysViewData(journeysViewData: res, data: data, depStop: self.depStop, arrStop: self.arrStop),.earlierRef)
					}
					.catch { error in Just(
						Event.didFailToLoadEarlierRef(error as? ApiServiceError ?? .badRequest))
					}
					.eraseToAnyPublisher()
			case .laterRef:
				guard let ref = state.laterRef else {
					print("🟤❌ >> laterRef is nil")
					return Just(Event.didFailToLoadLaterRef(.badUrl)).eraseToAnyPublisher()
				}
				return self.fetchEarlierOrLaterRef(dep: depStop, arr: arrStop, ref: ref, type: type,settings: self.settings)
					.mapError{ $0 }
					.asyncFlatMap { data in
						let res = await constructJourneysViewDataAsync(journeysData: data, depStop: self.depStop, arrStop: self.arrStop)
						return Event.onNewJourneysData(JourneysViewData(journeysViewData: res, data: data, depStop: self.depStop, arrStop: self.arrStop),.laterRef)
					}
					.catch { error in Just(
						Event.didFailToLoadLaterRef(error as? ApiServiceError ?? .badRequest))
					}
					.eraseToAnyPublisher()
			}
		}
	}
	
	func fetchEarlierOrLaterRef(dep : Stop,arr : Stop,ref : String, type : JourneyUpdateType,settings : ChewSettings) -> AnyPublisher<JourneysContainer,ApiServiceError> {
		var query = addJourneysStopsQuery(dep: dep, arr: arr)
		query += Query.getQueryItems(methods: [
			type == .earlierRef ? Query.earlierThan(earlierRef: ref) : Query.laterThan(laterRef: ref),
			Query.remarks(showRemarks: true),
			Query.results(max: 3),
			Query.stopovers(isShowing: true)
		])
		query += self.addJourneysTransportModes(settings: settings)
		return ApiService.fetchCombine(JourneysContainer.self,query: query, type: ApiService.Requests.journeys, requestGroupId: "")
	}
}

