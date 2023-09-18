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
	
	func whenLoadingStops() -> Feedback<State, Event> {
		Feedback { (state: State) -> AnyPublisher<Event, Never> in
			guard case .loading(let string, let type) = state.status else {
				return Empty().eraseToAnyPublisher()
			}
			return SearchLocationViewModel.fetchLocations(text: string, type: type)
				.map { stops in
					if stops.isEmpty {
						return Event.onDataLoadError(ApiServiceError.stopNotFound)
					}
					return Event.onDataLoaded(stops,type)
				}
				.catch { error in Just(.onDataLoadError(error)) }
				.eraseToAnyPublisher()
		}
	}
}


extension SearchLocationViewModel {
	static func fetchLocations(text : String, type : LocationDirectionType) -> AnyPublisher<[Stop],ApiServiceError> {
		var query : [URLQueryItem] = []
		query = Query.getQueryItems(methods: [
			Query.location(location: text),
			Query.results(max: 5),
			Query.showAddresses(showAddresses: false),
			Query.showPointsOfInterests(showPointsOfInterests: false)
		])
		return ApiService.fetchCombine([Stop].self,query: query, type: ApiService.Requests.locations(name: text ), requestGroupId: "")
	}
}

