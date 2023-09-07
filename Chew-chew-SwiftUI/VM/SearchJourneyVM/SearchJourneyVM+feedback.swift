//
//  SearchJourneyVM+feedback.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 06.09.23.
//

import Foundation
import Combine

extension SearchJourneyViewModel {
	static func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
		Feedback { _ in
			return input
		}
	}
	
	func whenLoading() -> Feedback<State, Event> {
	  Feedback { (state: State) -> AnyPublisher<Event, Never> in
		  guard case .loadingJourneys = state else { return Empty().eraseToAnyPublisher() }
		  return self.fetchJourneys()
			  .map { data in
				  return Event.onNewJourneysData(data)
			  }
			  .catch { error in Just(.onFailedToLoadJourneysData(error))}
			  .eraseToAnyPublisher()
	  }
	}
	
	func whenIdleCheckForSufficientDataForJourneyRequest() -> Feedback<State, Event> {
	  Feedback { (state: State) -> AnyPublisher<Event, Never> in
		  print(">> feedback : check for data")
		  guard case .idle = state else { return Empty().eraseToAnyPublisher() }
		  guard self.depStop != nil && self.arrStop != nil else { return Empty().eraseToAnyPublisher() }
		  return self.fetchJourneys()
			  .map { _ in
				  return Event.onJourneyDataUpdated
			  }
			  .catch { error in Just(.onFailedToLoadJourneysData(error))}
			  .eraseToAnyPublisher()
	  }
	}
}
