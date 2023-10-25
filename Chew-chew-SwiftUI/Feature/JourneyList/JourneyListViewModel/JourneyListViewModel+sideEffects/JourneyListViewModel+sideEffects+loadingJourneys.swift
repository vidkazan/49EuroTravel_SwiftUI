//
//  SearchJourneyVM+feedback.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 06.09.23.
//

import Foundation
import Combine

enum ChewError : Error {
	case error
}

extension JourneyListViewModel {
	
	func whenLoadingJourneys() -> Feedback<State, Event> {
		Feedback {(state: State) -> AnyPublisher<Event, Never> in
			guard case .loadingJourneys = state.status else { return Empty().eraseToAnyPublisher() }
			return self.fetchJourneys(dep: self.depStop, arr: self.arrStop, time: self.timeChooserDate.date,settings: self.settings)
				.mapError{ $0 }
				.asyncFlatMap { data in
					let res = await constructJourneysViewDataAsync(journeysData: data, depStop: self.depStop, arrStop: self.arrStop)
					return Event.onNewJourneysData(
						JourneysViewData(
							journeysViewData: res,
							data: data,
							depStop: self.depStop,
							arrStop: self.arrStop
						),
						JourneyUpdateType.initial
					)
				}
				.catch { error in Just(Event.onFailedToLoadJourneysData(error as? ApiServiceError ?? .badRequest))}
				.eraseToAnyPublisher()
		}
	}
	
	func addJourneysStopsQuery(dep : Stop,arr : Stop) -> [URLQueryItem] {
		var query : [URLQueryItem] = []
		switch dep.type {
		case .location:
			query += Query.getQueryItems(methods: [
				Query.departureAddress(addr: dep.name),
				Query.departureLatitude(departureLatitude: (String(dep.coordinates.latitude))),
				Query.departureLongitude(departureLongitude: (String(dep.coordinates.longitude)))
			])
		case .pointOfInterest:
			guard let id = dep.stopDTO?.id else {
				print("fetchJourneys","departure poi id is NIL")
				return query
			}
			
			query += Query.getQueryItems(methods: [
				Query.departurePoiId(poiId: id),
				Query.departureLatitude(departureLatitude: (String(dep.coordinates.latitude ))),
				Query.departureLongitude(departureLongitude: (String(dep.coordinates.longitude )))
			])
		case .stop:
			guard let depStop = dep.stopDTO?.id else {
				print("fetchJourneys","departure stop id is NIL")
				return query
			}
			query += Query.getQueryItems(methods: [
				Query.departureStopId(departureStopId: depStop)
			])
		}
		
		switch arr.type {
		case .location:
			query += Query.getQueryItems(methods: [
				Query.arrivalAddress(addr: arr.name),
				Query.arrivalLatitude(arrivalLatitude: (String(arr.coordinates.latitude))),
				Query.arrivalLongitude(arrivalLongitude: (String(arr.coordinates.longitude)))
			])
		case .pointOfInterest:
			guard let id = arr.stopDTO?.id else {
				print("fetchJourneys","arr pointOfInterest id is NIL")
				return query
			}
			query += Query.getQueryItems(methods: [
				Query.arrivalPoiId(poiId: id),
				Query.arrivalLatitude(arrivalLatitude: (String(arr.coordinates.latitude))),
				Query.arrivalLongitude(arrivalLongitude: (String(arr.coordinates.longitude)))
			])
		case .stop:
			guard let depStop = arr.stopDTO?.id else {
				print("fetchJourneys","arr stop id is NIL")
				return query
			}
			query += Query.getQueryItems(methods: [
				Query.arrivalStopId(arrivalStopId: depStop)
			])
		}
		return query
	}
	
	
	func addJourneysTransfersQuery(settings : ChewSettings) -> [URLQueryItem] {
		switch settings.transferTime {
		case .direct:
			return Query.getQueryItems(methods: [
				Query.transfersCount(0)
			])
		case .time(minutes: let minutes):
			return Query.getQueryItems(methods: [
				Query.transferTime(transferTime: minutes)
			])
		}
	}
	
	func addJourneysTransportModes(settings : ChewSettings) -> [URLQueryItem] {
		switch settings.transportMode {
		case .all:
			return []
		case .deutschlandTicket:
			return Query.getQueryItems(
				methods: [
					Query.national(icTrains: false),
					Query.nationalExpress(iceTrains: false),
					Query.regionalExpress(reTrains: false),
				]
			)
		case .custom(types: let products):
			return Query.getQueryItems(
				methods: [
					Query.national(icTrains: products.national ?? true),
					Query.nationalExpress(iceTrains: products.nationalExpress ?? true),
					Query.regionalExpress(reTrains: products.regionalExpress ?? true),
					Query.regional(rbTrains: products.regional ?? true),
					Query.suburban(sBahn: products.suburban ?? true),
					Query.ferry(ferry: products.ferry ?? true),
					Query.tram(tram: products.tram ?? true),
					Query.taxi(taxi: products.taxi ?? true),
				]
			)
		}
	}
	
	func fetchJourneys(dep : Stop,arr : Stop,time: Date, settings : ChewSettings) -> AnyPublisher<JourneysContainer,ApiServiceError> {
		var query = addJourneysStopsQuery(dep: dep, arr: arr)
		query += addJourneysTransfersQuery(settings: settings)
		query += addJourneysTransportModes(settings: settings)
		query += Query.getQueryItems(
			methods: [
				Query.departureTime(departureTime: time),
				Query.remarks(showRemarks: true),
				Query.results(max: 5),
				Query.stopovers(isShowing: true),
				Query.pretty(pretyIntend: settings.debugSettings.prettyJSON),
			]
		)
		return ApiService.fetchCombine(JourneysContainer.self,query: query, type: ApiService.Requests.journeys, requestGroupId: "")
	}
}

