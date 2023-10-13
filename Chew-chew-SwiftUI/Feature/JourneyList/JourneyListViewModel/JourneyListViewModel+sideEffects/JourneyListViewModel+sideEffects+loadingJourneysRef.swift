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
				  return Empty().eraseToAnyPublisher()
			  }
			  return self.fetchEarlierOrLaterRef(dep: depStop, arr: arrStop, ref: ref, type: type)
				  .mapError{ $0 }
				  .asyncFlatMap { data in
					  let res = await constructJourneysViewDataAsync(journeysData: data, depStop: self.depStop, arrStop: self.arrStop)
					  return Event.onNewJourneysData(JourneysViewData(journeysViewData: res, data: data, depStop: self.depStop, arrStop: self.arrStop),.earlierRef)
				  }
				  .catch { _ in Just(Event.onFailedToLoadJourneysData(.badRequest))}
				  .eraseToAnyPublisher()
		  case .laterRef:
			  guard let ref = state.laterRef else {
				  print("🟤❌ >> laterRef is nil")
				  return Just(.onFailedToLoadJourneysData(.badRequest)).eraseToAnyPublisher()
			  }
			  return self.fetchEarlierOrLaterRef(dep: depStop, arr: arrStop, ref: ref, type: type)
				  .mapError{ $0 }
				  .asyncFlatMap { data in
					  let res = await constructJourneysViewDataAsync(journeysData: data, depStop: self.depStop, arrStop: self.arrStop)
					  return Event.onNewJourneysData(JourneysViewData(journeysViewData: res, data: data, depStop: self.depStop, arrStop: self.arrStop),.laterRef)
				  }
				  .catch { _ in Just(Event.onFailedToLoadJourneysData(.badRequest))}
				  .eraseToAnyPublisher()
		  }
	  }
	}
	
	func fetchEarlierOrLaterRef(dep : LocationType,arr : LocationType,ref : String, type : JourneyUpdateType) -> AnyPublisher<JourneysContainer,ApiServiceError> {
		var query = addJourneysStopsQuery(dep: dep, arr: arr)
			query += Query.getQueryItems(methods: [
				type == .earlierRef ? Query.earlierThan(earlierRef: ref) : Query.laterThan(laterRef: ref),
				Query.national(icTrains: false),
				Query.nationalExpress(iceTrains: false),
				Query.regionalExpress(reTrains: false),
				Query.pretty(pretyIntend: false),
				Query.taxi(taxi: false),
				Query.remarks(showRemarks: true),
				Query.results(max: 3),
				Query.stopovers(isShowing: true)
			])
			return ApiService.fetchCombine(JourneysContainer.self,query: query, type: ApiService.Requests.journeys, requestGroupId: "")
	}
}

