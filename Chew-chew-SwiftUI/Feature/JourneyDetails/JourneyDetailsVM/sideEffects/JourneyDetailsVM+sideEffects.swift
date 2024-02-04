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
	
	static 	func whenChangingSubscribitionType() -> Feedback<State, Event> {
		Feedback { (state: State) -> AnyPublisher<Event, Never> in
			guard case let .changingSubscribingState(id,ref, vm) = state.status else {
				return Empty().eraseToAnyPublisher()
			}
			
			switch state.data.chewVM?.journeyFollowViewModel.state.journeys.contains(where: {$0.id == id}) == true {
			case true:
				state.data.chewVM?.journeyFollowViewModel.send(
					event: .didTapEdit(
						action: .deleting,
						journeyRef: ref,
						followData: nil,
						journeyDetailsViewModel: vm
					)
				)
			case false:
				state.data.chewVM?.journeyFollowViewModel.send(
					event: .didTapEdit(
						action: .adding,
						journeyRef: ref,
						followData: JourneyFollowData(
							id : Int64(ref.hashValue),
							journeyViewData: state.data.viewData,
							depStop: state.data.depStop,
							arrStop: state.data.arrStop
						),
						journeyDetailsViewModel: vm
					)
				)
			}
			return Empty().eraseToAnyPublisher()
		}
	}

	static 	func whenLoadingFullLeg() -> Feedback<State, Event> {
		Feedback { (state: State) -> AnyPublisher<Event, Never> in
			guard case .loadingFullLeg(leg: let leg) = state.status else {
				return Empty().eraseToAnyPublisher()
			}
			return Self.fetchTrip(tripId: leg.tripId)
				.mapError{ $0 }
				.asyncFlatMap {  res in
					let leg = try constructLegDataThrows(
						leg: res,
						firstTS: DateParcer.getDateFromDateString(dateString: res.plannedDeparture),
						lastTS: DateParcer.getDateFromDateString(dateString: res.plannedArrival),
						legs: nil
					)
					return Event.didLoadFullLegData(data: leg)
				}
				.catch { error in
					state.data.chewVM?.alertViewModel.send(event: .didRequestShow(.fullLegError))
					return Just(Event.didFailToLoadTripData(error: error as! (any ChewError))).eraseToAnyPublisher()
				}
				.eraseToAnyPublisher()
		}
	}
	
	
	static func fetchTrip(tripId : String) -> AnyPublisher<LegDTO,ApiServiceError> {
		return ApiService().fetch(
			TripDTO.self,
			query: [],
			type: ApiService.Requests.trips(tripId: tripId)
		)
		.map { $0.trip }
		.eraseToAnyPublisher()
	}
	
	static func fetchJourneyByRefreshToken(id : Int64?,ref : String) -> (Int64?,AnyPublisher<JourneyWrapper,ApiServiceError>) {
		return (id, ApiService().fetch(
			JourneyWrapper.self,
			query: Query.getQueryItems(
				methods: [
					Query.stopovers(isShowing: true),
					Query.polylines(true),
				]
			),
			type: ApiService.Requests.journeyByRefreshToken(ref: ref)
		)
		.eraseToAnyPublisher())
	}
	
	static func whenLoadingIfNeeded() -> Feedback<State, Event> {
		Feedback {(state: State) -> AnyPublisher<Event, Never> in
			switch state.status {
			case let .loadingIfNeeded(id,token,status):
				if Date.now.timeIntervalSince1970 - state.data.viewData.updatedAt < status.updateIntervalInMinutes * 60 {
					return Just(Event.didCancelToLoadData).eraseToAnyPublisher()
				}
				return Just(Event.didTapReloadButton(id: id,ref: token)).eraseToAnyPublisher()
			default:
				return Empty().eraseToAnyPublisher()
			}
		}
	}
	
	static func whenLoadingJourneyByRefreshToken() -> Feedback<State, Event> {
		Feedback { (state: State) -> AnyPublisher<Event, Never> in
			var token : String!
			var followId : Int64?
			
			switch state.status {
			case let .loading(id, ref):
				token = ref
				followId = id
			default:
				return Empty().eraseToAnyPublisher()
			}
			
			guard let token = token else {
				return Just(Event.didFailedToLoadJourneyData(
					error: Error.inputValIsNil("journeyRef"))
				)
				.eraseToAnyPublisher()
			}

			let res = Self.fetchJourneyByRefreshToken(id: followId, ref: token)
			return res.1
				.mapError{ $0 }
				.asyncFlatMap{ data in
					let res = await constructJourneyViewDataAsync(
						journey: data.journey,
						depStop: state.data.depStop,
						arrStop: state.data.arrStop,
						realtimeDataUpdatedAt: Date.now.timeIntervalSince1970
					)
					
					guard let res = res else {
						return Event.didFailedToLoadJourneyData(
							error: Error.inputValIsNil("viewData")
						)
					}
					#warning("BUG: some journeys from geoLocation doesnt save in DB")
					switch state.data.chewVM?.journeyFollowViewModel.state.journeys.contains(where: {$0.id == followId}) == true {
					case true:
						guard let id = followId else {
							return Event.didFailedToLoadJourneyData(
								error: Error.inputValIsNil("followId")
							)
						}
						guard state.data.chewVM?.coreDataStore.updateJourney(
							   id: id,
							   viewData: res,
							   depStop: state.data.depStop,
							   arrStop: state.data.arrStop) == true else {
							return Event.didFailedToLoadJourneyData(
								error: CoreDataError.failedToUpdateDatabase(type: ChewJourney.self))
						}
						state.data.chewVM?.journeyFollowViewModel.send(event: .didUpdateJourney(res))
					case false:
						break
					}
					return Event.didLoadJourneyData(data: res)
				}
				.catch {
					error in Just(.didFailedToLoadJourneyData(error: error as! (any ChewError)))
				}
				.eraseToAnyPublisher()
		}
	}
}

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
