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
	static func whenLoadingUserLocation() -> Feedback<State, Event> {
		Feedback { (state: State) -> AnyPublisher<Event, Never> in
			guard case .loadingLocation(let send) = state.status else {
				return Empty().eraseToAnyPublisher()
			}
			
			switch Model.shared.locationDataManager.authorizationStatus {
			case .notDetermined,.restricted,.denied,.none:
				Model.shared.alertViewModel.send(event: .didRequestShow(.userLocationError))
				return Just(Event.didFailToLoadLocationData).eraseToAnyPublisher()
			case .authorizedAlways,.authorizedWhenInUse:
				guard let coords = Model.shared.locationDataManager.locationManager.location?.coordinate else {
					Model.shared.alertViewModel.send(event: .didRequestShow(.userLocationError))
					return Just(Event.didFailToLoadLocationData).eraseToAnyPublisher()
				}
				Task {
					await Self.reverseGeocoding(coords : coords ,send:send)
				}
				return Empty().eraseToAnyPublisher()
			@unknown default:
				Model.shared.alertViewModel.send(event: .didRequestShow(.userLocationError))
				return Just(Event.didFailToLoadLocationData).eraseToAnyPublisher()
			}
		}
	}
	
	private static func reverseGeocoding(coords : CLLocationCoordinate2D,send : (ChewViewModel.Event)->Void) async {
		Model.shared.alertViewModel.send(event: .didRequestDismiss(.userLocationError))
		
		if let res = try? await CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: coords.latitude, longitude: coords.longitude)).first,
		   let name = res.name, let city = res.locality {
			let stop = Stop(
				coordinates: coords,
				type: .location,
				stopDTO: StopDTO(name: String(name + ", " + city))
			)
			send(Event.didReceiveLocationData(stop))
		} else {
			let stop = Stop(
				coordinates: coords,
				type: .location,
				stopDTO: StopDTO(name: String(coords.latitude).prefix(6) + " " + String(coords.longitude).prefix(6))
			)
			send(Event.didReceiveLocationData(stop))
		}
	}
}

