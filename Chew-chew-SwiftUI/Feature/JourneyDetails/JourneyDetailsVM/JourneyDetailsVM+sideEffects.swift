//
//  JourneyDetailsVM+sideEffect.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.09.23.
//

import Foundation
import Combine

extension JourneyDetailsViewModel {
	static func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
		Feedback { _ in
			return input
		}
	}
	
//	func whenLoadingJourneyByRefreshToken() -> Feedback<State, Event> {
//	  Feedback {[self] (state: State) -> AnyPublisher<Event, Never> in
//		  guard case .loading(refreshToken: let ref) = state.status else { return Empty().eraseToAnyPublisher() }
//			  return self.fetchJourneyByRefreshToken(ref: ref)
//				  .map { data in
//					  return Event.didLoadJourneyData(data: data)
//				  }
//				  .catch {
//					  error in Just(.didFailedToLoadJourneyData(error: error))
//				  }
//				  .eraseToAnyPublisher()
//		  }
//	}
	
//	func whenLoadingData() -> Feedback<State, Event> {
//	  Feedback { (state: State) -> AnyPublisher<Event, Never> in
//		  guard case .loading = state.status else { return Empty().eraseToAnyPublisher() }
////			  let subject = Future<(lat:Double,long:Double),ApiServiceError> { promise in
////				  return promise(.failure(.failedToGetUserLocation))
////			  }
////			  return subject.eraseToAnyPublisher()
//		  return Just(.didLoadJourneyData(data: .init(legsViewData: []))).eraseToAnyPublisher()
//
//		  }
//	}
	
	func fetchJourneyByRefreshToken(ref : String?) -> AnyPublisher<Journey,ApiServiceError> {
		return ApiService.fetchCombine(Journey.self,query: [], type: ApiService.Requests.journeyByRefreshToken(ref: ref), requestGroupId: "")
	}
}