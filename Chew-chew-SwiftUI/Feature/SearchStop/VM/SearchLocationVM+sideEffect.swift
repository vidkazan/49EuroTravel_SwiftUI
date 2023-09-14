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
	
//	func whenLoadingUserLocation() -> Feedback<State, Event> {
//		Feedback { (state: State) -> AnyPublisher<Event, Never> in
//			guard case .loadingLocation = state.status else {
//				return Empty().eraseToAnyPublisher()
//			}
//			return self.requestUserLocation()
//				.map { res in
//					return Event.didReceiveLocaitonData(lat: res.lat, long: res.long)
//				}
//				.catch { error in Just(.didFailToLoadLocationData) }
//				.eraseToAnyPublisher()
//		}
//	}
	
	
	func whenLoadingStops() -> Feedback<State, Event> {
		Feedback { (state: State) -> AnyPublisher<Event, Never> in
			guard case .loading(let string, let type) = state.status else {
				return Empty().eraseToAnyPublisher()
			}
			print(">> fetch")
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
//	func requestUserLocation() -> AnyPublisher<(lat:Double,long:Double),ApiServiceError> {
//		switch locationDataManager.authorizationStatus {
//		case .notDetermined:
//			return Empty().eraseToAnyPublisher()
//		case .restricted,.denied:
//			let subject = Future<(lat:Double,long:Double),ApiServiceError> { promise in
//				return promise(.failure(.failedToGetUserLocation))
//			}
//			return subject.eraseToAnyPublisher()
//		case .authorizedAlways,.authorizedWhenInUse:
//			let lat = locationDataManager.locationManager.location?.coordinate.latitude ?? 0
//			let long = locationDataManager.locationManager.location?.coordinate.longitude ?? 0
//			return Just((lat:lat,long:long)).setFailureType(to: ApiServiceError.self).eraseToAnyPublisher()
//		case .none:
//			return Empty().eraseToAnyPublisher()
//		@unknown default:
//			return Empty().eraseToAnyPublisher()
//		}
//	}
	
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

