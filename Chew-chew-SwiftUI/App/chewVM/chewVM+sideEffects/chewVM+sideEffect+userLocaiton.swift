//
//  +sideEffect.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.09.23.
//

import Combine
import Foundation

extension ChewViewModel {
	
	func whenLoadingUserLocation() -> Feedback<State, Event> {
		Feedback { (state: State) -> AnyPublisher<Event, Never> in
			guard case .loadingLocation = state.status else {
				return Empty().eraseToAnyPublisher()
			}
			return self.requestUserLocation()
				.map { res in
					return Event.didReceiveLocationData(lat: res.lat, long: res.long)
				}
				.catch { error in Just(.didFailToLoadLocationData) }
				.eraseToAnyPublisher()
		}
	}
	func requestUserLocation() -> AnyPublisher<(lat:Double,long:Double),ApiServiceError> {
		switch locationDataManager.authorizationStatus {
		case .notDetermined:
			return Empty().eraseToAnyPublisher()
		case .restricted,.denied:
			let subject = Future<(lat:Double,long:Double),ApiServiceError> { promise in
				return promise(.failure(.failedToGetUserLocation))
			}
			return subject.eraseToAnyPublisher()
		case .authorizedAlways,.authorizedWhenInUse:
			let lat = locationDataManager.locationManager.location?.coordinate.latitude ?? 0
			let long = locationDataManager.locationManager.location?.coordinate.longitude ?? 0
			return Just((lat:lat,long:long)).setFailureType(to: ApiServiceError.self).eraseToAnyPublisher()
		case .none:
			return Empty().eraseToAnyPublisher()
		@unknown default:
			return Empty().eraseToAnyPublisher()
		}
	}
}
