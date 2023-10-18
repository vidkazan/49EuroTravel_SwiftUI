//
//  +sideEffect.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.09.23.
//

import Combine
import Foundation
import CoreLocation

extension ChewViewModel {
	// TODO: reverse geocoding https://medium.com/aeturnuminc/geocoding-in-swift-611bda45efe1 or https://nominatim.openstreetmap.org/reverse?lon=10.78008628451338&lat=52.4212646484375&format=json&pretty=true
	func whenLoadingUserLocation() -> Feedback<State, Event> {
		Feedback { (state: State) -> AnyPublisher<Event, Never> in
			guard case .loadingLocation = state.status else {
				return Empty().eraseToAnyPublisher()
			}
			return self.requestUserLocation()
				.map { res in
					switch res {
					case .success(let coord):
						return Event.didReceiveLocationData(coord)
					case .failure:
						return Event.didFailToLoadLocationData
					}
				}
				.eraseToAnyPublisher()
		}
	}
	func requestUserLocation() -> AnyPublisher<Result<CLLocationCoordinate2D,ApiServiceError>,Never> {
		switch locationDataManager.authorizationStatus {
		case .notDetermined,.restricted,.denied,.none:
			return Just(Result.failure(ApiServiceError.failedToGetUserLocation))
				.eraseToAnyPublisher()
		case .authorizedAlways,.authorizedWhenInUse:
			let lat = locationDataManager.locationManager.location?.coordinate.latitude
			let long = locationDataManager.locationManager.location?.coordinate.longitude
			guard let lat = lat,let long = long else {
				return Just(Result.failure(ApiServiceError.failedToGetUserLocation))
					.eraseToAnyPublisher()
			}
			return Just(
				Result.success(
					CLLocationCoordinate2D(
						latitude: lat,
						longitude: long
					)
				)
			).eraseToAnyPublisher()
		@unknown default:
			return Just(Result.failure(ApiServiceError.failedToGetUserLocation))
				.eraseToAnyPublisher()
		}
	}
}

