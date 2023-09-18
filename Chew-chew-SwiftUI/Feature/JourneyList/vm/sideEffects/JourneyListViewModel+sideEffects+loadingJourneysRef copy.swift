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
			  return  Just(.onFailedToLoadJourneysData(.badRequest)).eraseToAnyPublisher()
		  case .earlierRef:
			  guard let ref = state.earlierRef else { return Just(.onFailedToLoadJourneysData(.badRequest)).eraseToAnyPublisher() }
			  return self.fetchEarlierOrLaterRef(dep: depStop, arr: arrStop, ref: ref, type: type)
				  .map { data in
					  return Event.onNewJourneysData(data,type)
				  }
				  .catch { error in Just(.onFailedToLoadJourneysData(error))}
				  .eraseToAnyPublisher()
		  case .laterRef:
			  guard let ref = state.laterRef else { return Just(.onFailedToLoadJourneysData(.badRequest)).eraseToAnyPublisher() }
			  return self.fetchEarlierOrLaterRef(dep: depStop, arr: arrStop, ref: ref, type: type)
				  .map { data in
					  return Event.onNewJourneysData(data,type)
				  }
				  .catch { error in Just(.onFailedToLoadJourneysData(error))}
				  .eraseToAnyPublisher()
		  }
	  }
	}
	
	func fetchEarlierOrLaterRef(dep : StopType,arr : StopType,ref : String, type : JourneyUpdateType) -> AnyPublisher<JourneysContainer,ApiServiceError> {
		var query = addJourneysStopsQuery(dep: dep, arr: arr)
		
			query += Query.getQueryItems(methods: [
				type == .earlierRef ? Query.earlierThan(earlierRef: ref) : Query.laterThan(laterRef: ref),
				Query.national(icTrains: false),
				Query.nationalExpress(iceTrains: false),
				Query.regionalExpress(reTrains: false),
				Query.pretty(pretyIntend: false),
				Query.taxi(taxi: false),
				Query.remarks(showRemarks: true),
				Query.results(max: 5)
			])
			return ApiService.fetchCombine(JourneysContainer.self,query: query, type: ApiService.Requests.journeys, requestGroupId: "")
	}
}

