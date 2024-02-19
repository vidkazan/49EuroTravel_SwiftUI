//
//  SearchLocationVM+feedback.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 06.09.23.
//

import Foundation
import Combine

extension SearchStopsViewModel {
	static func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
		Feedback { _ in
			input
		}
	}
	
	static func whenLoadingStops() -> Feedback<State, Event> {
		Feedback { (state: State) -> AnyPublisher<Event, Never> in
			guard case .loading(let string) = state.status,
				  let type = state.type else {
				return Empty().eraseToAnyPublisher()
			}
			return SearchStopsViewModel.fetchLocations(text: string, type: type)
				.map { stops in
					if stops.isEmpty {
						return Event.onDataLoadError(ApiError.stopNotFound)
					}
					let stops = stops.compactMap { stop -> Stop? in
						return stop.stop()
					}
					return Event.onDataLoaded(stops,type)
				}
				.catch { error in
					if let error = error as? ApiError {
						return Just(Event.onDataLoadError(error))
					}
					return Just(Event.onDataLoadError(ApiError.badRequest))
				}
				.eraseToAnyPublisher()
		}
	}
	
	static func whenUpdatingRecentStops() -> Feedback<State, Event> {
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
	static func fetchLocations(text : String, type : LocationDirectionType) -> AnyPublisher<[StopDTO],ApiError> {
		var query : [URLQueryItem] = []
		query = Query.queryItems(methods: [
			Query.location(location: text),
			Query.results(max: 10)
		])
		return ApiService().fetch([StopDTO].self,query: query, type: ApiService.Requests.locations)
	}
}

