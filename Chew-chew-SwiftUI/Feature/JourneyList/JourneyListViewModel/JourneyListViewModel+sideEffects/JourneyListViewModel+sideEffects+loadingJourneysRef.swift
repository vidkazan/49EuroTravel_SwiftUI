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
		Feedback {[weak self] (state: State) -> AnyPublisher<Event, Never> in
			guard case .loadingRef(let type) = state.status else { return Empty().eraseToAnyPublisher() }
			switch type {
			case .initial:
				return Just(Event.onReloadJourneyList).eraseToAnyPublisher()
			case .earlierRef:
				guard let self = self else { return Just(Event.didFailToLoadEarlierRef(Error.inputValIsNil("self"))).eraseToAnyPublisher() }
				guard let ref = state.earlierRef else {
					print("🟤❌ >> earlierRef is nil")
					return Just(Event.didFailToLoadEarlierRef(Error.inputValIsNil("earlierRef"))).eraseToAnyPublisher()
				}
				return self.fetchEarlierOrLaterRef(dep: depStop, arr: arrStop, ref: ref, type: type,settings: self.settings)
					.mapError{ $0 }
					.asyncFlatMap { data in
						let res = await constructJourneyListViewDataAsync(
							journeysData: data,
							depStop: self.depStop,
							arrStop: self.arrStop
						)
						return Event.onNewJourneyListData(JourneyListViewData(journeysViewData: res, data: data, depStop: self.depStop, arrStop: self.arrStop),.earlierRef)
					}
					.catch { error in
						Just(Event.didFailToLoadEarlierRef(error as? any ChewError ?? ApiServiceError.generic(error)))
					}
					.eraseToAnyPublisher()
			case .laterRef:
				guard let self = self else { return Just(Event.didFailToLoadLaterRef(Error.inputValIsNil("self"))).eraseToAnyPublisher() }
				guard let ref = state.laterRef else {
					print("🟤❌ >> laterRef is nil")
					return Just(Event.didFailToLoadEarlierRef(Error.inputValIsNil("laterRef"))).eraseToAnyPublisher()
				}
				return self.fetchEarlierOrLaterRef(dep: depStop, arr: arrStop, ref: ref, type: type,settings: self.settings)
					.mapError{ $0 }
					.asyncFlatMap { data in
						let res = await constructJourneyListViewDataAsync(journeysData: data, depStop: self.depStop, arrStop: self.arrStop)
						return Event.onNewJourneyListData(JourneyListViewData(journeysViewData: res, data: data, depStop: self.depStop, arrStop: self.arrStop),.laterRef)
					}
					.catch { error in
						Just(Event.didFailToLoadLaterRef(error as? any ChewError ?? ApiServiceError.generic(error)))
					}
					.eraseToAnyPublisher()
			}
		}
	}
	
	func fetchEarlierOrLaterRef(dep : Stop,arr : Stop,ref : String, type : JourneyUpdateType,settings : ChewSettings) -> AnyPublisher<JourneyListDTO,ApiServiceError> {
		var query = addJourneyListStopsQuery(dep: dep, arr: arr)
		query += Query.getQueryItems(methods: [
			type == .earlierRef ? Query.earlierThan(earlierRef: ref) : Query.laterThan(laterRef: ref),
			Query.remarks(showRemarks: true),
			Query.results(max: 3),
			Query.stopovers(isShowing: true)
		])
		query += self.addJourneyListTransportModes(settings: settings)
		return ApiService().fetch(JourneyListDTO.self,query: query, type: ApiService.Requests.journeys)
	}
}

