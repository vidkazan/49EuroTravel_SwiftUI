//
//  SearchJourneyVM+feedback.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 06.09.23.
//

import Foundation
import Combine

extension JourneyListViewModel {
	func whenLoadingJourneyByRefreshToken() -> Feedback<State, Event> {
	  Feedback {[self] (state: State) -> AnyPublisher<Event, Never> in
		  guard case .loadingRef(let type) = state.status else { return Empty().eraseToAnyPublisher() }
			  return self.fetchJourneyByRefreshToken(ref: ref)
				  .map { data in
					  return Event.onNewJourneysData(data,type)
				  }
				  .catch { error in Just(.onFailedToLoadJourneysData(error))}
				  .eraseToAnyPublisher()
		  }
	  }
	
	func fetchJourneyByRefreshToken(ref : String) -> AnyPublisher<JourneysContainer,ApiServiceError> {
			return ApiService.fetchCombine(JourneysContainer.self,query: [], type: ApiService.Requests.journeys, requestGroupId: "")
	}
}

