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
	static func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
		Feedback { _ in
			return input
		}
	}
	
	func whenLoadingJourneyByRefreshToken() -> Feedback<State, Event> {
		Feedback {[weak self] (state: State) -> AnyPublisher<Event, Never> in
			guard
				case .loading(refreshToken: let ref) = state.status,
				let ref = ref else { return Empty().eraseToAnyPublisher() }
			return Self.fetchJourneyByRefreshToken(ref: ref)
				.map { data in
					return Event.didLoadJourneyData(
						data: constructJourneyViewData(
							journey: data,
							depStop: self?.depStop,
							arrStop: self?.arrStop
						))
				}
				.catch {
					error in Just(.didFailedToLoadJourneyData(error: error))
				}
				.eraseToAnyPublisher()
		}
	}
	
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
			latitudeDelta: latitudinalDelta * 2,
			longitudeDelta: longitudinalDelta * 2
		)
		
		// Create and return the region
		return MKCoordinateRegion(center: centerCoordinate, span: span)
	}
	
	static func whenLoadingLocationDetails() -> Feedback<State, Event> {
		Feedback { (state: State) -> AnyPublisher<Event, Never> in
			guard case .loadingLocationDetails(leg: let leg) = state.status else {
				return Empty().eraseToAnyPublisher()
			}
			if let locFirst = leg.legStopsViewData.first?.locationCoordinates,
			   let locLast = leg.legStopsViewData.last?.locationCoordinates {
				
				return Just(Event.didLoadLocationDetails(
					coordRegion: constructMapRegion(locFirst: locFirst, locLast: locLast),
					coordinates: [locFirst,locLast]
				))
				.eraseToAnyPublisher()
			}
			return Empty().eraseToAnyPublisher()
		}
	}
	
	static func whenLoadingFullLeg() -> Feedback<State, Event> {
		Feedback { (state: State) -> AnyPublisher<Event, Never> in
			guard case .loadingFullLeg(leg: let leg) = state.status else {
				return Empty().eraseToAnyPublisher()
			}
			return fetchTrip(tripId: leg.tripId)
				.mapError{ $0 }
				.map { res in
					let leg = constructLegData(
						leg: res,
						firstTS: DateParcer.getDateFromDateString(dateString: res.plannedDeparture),
						lastTS: DateParcer.getDateFromDateString(dateString: res.plannedArrival),
						legs: nil
					)
					if let leg = leg {
						return Event.didLoadFullLegData(data: leg)
					} else {
						return Event.didCloseBottomSheet
					}
				}
				.catch { error in Empty().eraseToAnyPublisher()}
				.eraseToAnyPublisher()
		}
	}
	
	
	static func fetchTrip(tripId : String) -> AnyPublisher<Leg,ApiServiceError> {
		return ApiService.fetchCombine(
			Trip.self,
			query: [],
			type: ApiService.Requests.trips(tripId: tripId),
			requestGroupId: ""
		)
		.map {return $0.trip}
		.eraseToAnyPublisher()
	}
	
	static func fetchJourneyByRefreshToken(ref : String) -> AnyPublisher<Journey,ApiServiceError> {
		return ApiService.fetchCombine(
			JourneyWrapper.self,
			query: Query.getQueryItems(methods: [Query.stopovers(isShowing: true)]),
			type: ApiService.Requests.journeyByRefreshToken(ref: ref),
			requestGroupId: ""
		)
		.map { return $0.journey }
		.eraseToAnyPublisher()
	}
}
