//
//  SearchLocationVM+feedback.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 06.09.23.
//

import Foundation
import Combine

extension SearchStopsViewModel {
	func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
		Feedback { _ in
			input
		}
	}
	
	func whenLoadingStops() -> Feedback<State, Event> {
		Feedback { (state: State) -> AnyPublisher<Event, Never> in
			guard case .loading(let string) = state.status,
				  let type = state.type else {
				return Empty().eraseToAnyPublisher()
			}
			return SearchStopsViewModel.fetchLocations(text: string, type: type)
				.map { stops in
					if stops.isEmpty {
						return Event.onDataLoadError(ApiServiceError.stopNotFound)
					}
					let stops = stops.compactMap { stop -> Stop? in
						return constructStopFromStopDTO(data: stop)
					}
					return Event.onDataLoaded(stops,type)
				}
				.catch { error in Just(.onDataLoadError(error)) }
				.eraseToAnyPublisher()
		}
	}
	
	func whenUpdatingRecentStops() -> Feedback<State, Event> {
		Feedback { (state: State) -> AnyPublisher<Event, Never> in
			guard case .updatingRecentStops(let stop) = state.status,
			let stop = stop else {
				return Empty().eraseToAnyPublisher()
			}
			var recentStops = state.previousStops
			
			if !recentStops.contains(stop) {
				recentStops.insert(stop, at: 0)
			}
			return Just(Event.didRecentStopsUpdated(recentStops: recentStops))
				.eraseToAnyPublisher()
		}
	}
}


extension SearchStopsViewModel {
	static func fetchLocations(text : String, type : LocationDirectionType) -> AnyPublisher<[StopDTO],ApiServiceError> {
		var query : [URLQueryItem] = []
		query = Query.getQueryItems(methods: [
			Query.location(location: text),
			Query.results(max: 10)
		])
		return ApiService().fetch([StopDTO].self,query: query, type: ApiService.Requests.locations)
	}
}

