//
//  SearchLocationVM+feedback.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 06.09.23.
//

import Foundation
import Combine

extension SearchLocationViewModel {
	func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
		Feedback { _ in
			input
		}
	}
	
	func whenLoadingLocation() -> Feedback<State, Event> {
	  Feedback { (state: State) -> AnyPublisher<Event, Never> in
		  guard case .loading(let string, let type) = state else { return Empty().eraseToAnyPublisher() }

		  return SearchLocationViewModel.fetchLocations(text: string, type: .departure)
			  .map { stops in
				  return Event.onDataLoaded(stops,type)
			  }
			  .catch { error in Just(.onDataLoadError(error)) }
			  .eraseToAnyPublisher()
	  }
	}
}
