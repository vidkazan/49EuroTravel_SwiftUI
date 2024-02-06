//
//  JourneyDetailsVM+sideEffect.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.09.23.
//

import Foundation
import Combine
import CoreLocation
import MapKit

extension JourneyDetailsViewModel {
	private static func constructMapRegion(locFirst : CLLocationCoordinate2D, locLast : CLLocationCoordinate2D) -> MKCoordinateRegion {
		let centerCoordinate = CLLocationCoordinate2D(
			latitude: (locFirst.latitude + locLast.latitude) / 2,
			longitude: (locFirst.longitude + locLast.longitude) / 2
		)
		
		// Calculate the span (delta) between the two coordinates
		let latitudinalDelta = abs(locFirst.latitude - locLast.latitude)
		let longitudinalDelta = abs(locFirst.longitude - locLast.longitude)
		
		// Add a little padding to the span
		let span = MKCoordinateSpan(
			latitudeDelta: latitudinalDelta * 2 + 0.006,
			longitudeDelta: longitudinalDelta * 2 + 0.006
		)
		
		// Create and return the region
		return MKCoordinateRegion(center: centerCoordinate, span: span)
	}
	
	
	static func makeDirecitonsRequest(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D
	) -> AnyPublisher<MKDirections.Response, ApiServiceError> {
		let request = MKDirections.Request()
		request.source = MKMapItem(
			placemark: MKPlacemark(
				coordinate: from,
				addressDictionary: nil
			)
		)
		request.destination = MKMapItem(
			placemark: MKPlacemark(
				coordinate: to,
				addressDictionary: nil
			)
		)
		request.transportType = .walking
	
		let directions = MKDirections(request: request)
		
		
		let subject = Future<MKDirections.Response,ApiServiceError> { promise in
			directions.calculate { resp, error in
				if let error=error {
					return promise(.failure(.cannotConnectToHost(error.localizedDescription)))
				}
				guard let resp = resp else {
					return promise(.failure(ApiServiceError.cannotDecodeRawData))
				}
				return promise(.success(resp))
			}
		}
		return subject.eraseToAnyPublisher()
	}
	
	
	static func whenLoadingLocationDetails() -> Feedback<State, Event> {
		Feedback { (state: State) -> AnyPublisher<Event, Never> in
			guard case .loadingLocationDetails(leg: let leg) = state.status else {
				return Empty().eraseToAnyPublisher()
			}
			if let locFirst = leg.legStopsViewData.first,
			   let locLast = leg.legStopsViewData.last {
				switch leg.legType {
				case .footEnd,.footMiddle,.footStart:
					return makeDirecitonsRequest(from: locFirst.locationCoordinates, to: locLast.locationCoordinates)
						.map { res in
							return Event.didLoadLocationDetails(
								coordRegion: constructMapRegion(locFirst: locFirst.locationCoordinates, locLast: locLast.locationCoordinates),
								stops: [locFirst,locLast],
								route: res.routes.first?.polyline)
						}
						.catch { error in
							print("❌ whenLoadingLocationDetails: makeDirecitonsRequest: error:",error)
							return Just(Event.didLoadLocationDetails(
								coordRegion: constructMapRegion(locFirst: locFirst.locationCoordinates, locLast: locLast.locationCoordinates),
								stops: [locFirst,locLast],
								route: nil)
							)
						}
						.eraseToAnyPublisher()
				case .line:
					var polyline : MKPolyline? = nil
					if let features = leg.polyline?.features {
						let polylinePoints = features.compactMap {
							if let lat = $0.geometry?.coordinates[1],let long = $0.geometry?.coordinates[0] {
								return CLLocationCoordinate2DMake(lat, long)
							}
							return nil
						}
						polyline = MKPolyline(coordinates: polylinePoints, count: polylinePoints.count)
					} else {
						let polylinePoints = leg.legStopsViewData.compactMap {
							return $0.locationCoordinates
						}
						polyline = MKPolyline(coordinates: polylinePoints, count: polylinePoints.count)
					}
					return Just(Event.didLoadLocationDetails(
						coordRegion: constructMapRegion(locFirst: locFirst.locationCoordinates, locLast: locLast.locationCoordinates),
						stops: [locFirst,locLast],
						route: polyline)
					)
					.eraseToAnyPublisher()
				case .transfer:
					return Just(Event.didLoadLocationDetails(
						coordRegion: constructMapRegion(locFirst: locFirst.locationCoordinates, locLast: locLast.locationCoordinates),
						stops: [locFirst,locLast],
						route: nil)
					)
					.eraseToAnyPublisher()
				}
			}
			return Empty().eraseToAnyPublisher()
		}
	}
}
