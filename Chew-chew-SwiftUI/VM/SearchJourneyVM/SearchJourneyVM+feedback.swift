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
		  guard case .loadingJourneys = state.status else { return Empty().eraseToAnyPublisher() }
		  guard let dep = state.depStop, let arr = state.arrStop else { return Empty().eraseToAnyPublisher() }
		  return self.fetchJourneys(dep: dep, arr: arr, time: state.timeChooserDate)
				  .map { data in
					  return Event.onNewJourneysData(data)
				  }
				  .catch { error in Just(.onFailedToLoadJourneysData(error))}
				  .eraseToAnyPublisher()
	  }
	}
	
	
	func whenIdleCheckForSufficientDataForJourneyRequest() -> Feedback<State, Event> {
	  Feedback { (state: State) -> AnyPublisher<Event, Never> in
		  guard case .idle = state.status else { return Empty().eraseToAnyPublisher() }
		  print(">> feedback : check for data",state.arrStop,state.depStop)
		  guard state.depStop != nil && state.arrStop != nil else { return Empty().eraseToAnyPublisher() }
				return Just(Event.onJourneyDataUpdated)
			  .eraseToAnyPublisher()
	  }
	}
}
