//
//  SearchJourneyVM+feedback.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 06.09.23.
//

import Foundation
import Combine

extension JourneyListViewModel {
	static func whenLoadingJourneyList() -> Feedback<State, Event> {
		Feedback { (state: State) -> AnyPublisher<Event, Never> in
			guard case .loadingJourneyList = state.status else { return Empty().eraseToAnyPublisher() }
			return Self.fetchJourneyList(
				dep: state.data.stops.departure,
				arr: state.data.stops.arrival,
				time: state.data.date.date,
				settings: state.data.settings
			)
				.mapError{ $0 }
				.asyncFlatMap { data in
					let res = await constructJourneyListViewDataAsync(
						journeysData: data,
						depStop: state.data.stops.departure,
						arrStop: state.data.stops.arrival
					)
					return Event.onNewJourneyListData(
						JourneyListViewData(
							journeysViewData: res,
							data: data,
							depStop: state.data.stops.departure,
							arrStop: state.data.stops.arrival
						),
						JourneyUpdateType.initial
					)
				}
				.catch { error in Just(Event.onFailedToLoadJourneyListData(error as? ApiServiceError ?? .badRequest))}
				.eraseToAnyPublisher()
		}
	}
	
	static func addJourneyListStopsQuery(dep : Stop,arr : Stop) -> [URLQueryItem] {
		var query : [URLQueryItem] = []
		switch dep.type {
		case .location:
			query += [
				Query.address(addr: dep.name).queryItem().departure(),
				Query.latitude(latitude: (String(dep.coordinates.latitude))).queryItem().departure(),
				Query.longitude(longitude: (String(dep.coordinates.longitude))).queryItem().departure()
			]
		case .pointOfInterest:
			guard let id = dep.stopDTO?.id else {
				print("fetchJourneyList","departure poi id is NIL")
				return query
			}
			
			query += [
				Query.poiId(poiId: id).queryItem().departure(),
				Query.latitude(latitude: (String(dep.coordinates.latitude))).queryItem().departure(),
				Query.longitude(longitude: (String(dep.coordinates.longitude))).queryItem().departure(),
				Query.poiName(poiName: "name").queryItem().departure()
			]
		case .stop:
			guard let depStop = dep.stopDTO?.id else {
				print("fetchJourneyList","departure stop id is NIL")
				return query
			}
			query += Query.queryItems(methods: [
				Query.departureStopId(departureStopId: depStop)
			])
		}
		
		switch arr.type {
		case .location:
			query += [
				Query.address(addr: arr.name).queryItem().arrival(),
				Query.latitude(latitude: (String(arr.coordinates.latitude))).queryItem().arrival(),
				Query.longitude(longitude: (String(arr.coordinates.longitude))).queryItem().arrival(),
			]
		case .pointOfInterest:
			guard let id = arr.stopDTO?.id else {
				print("fetchJourneyList","arr pointOfInterest id is NIL")
				return query
			}
			query += [
				Query.poiId(poiId: id).queryItem().arrival(),
				Query.latitude(latitude: (String(arr.coordinates.latitude))).queryItem().arrival(),
				Query.longitude(longitude: (String(arr.coordinates.longitude))).queryItem().arrival(),
				Query.poiName(poiName: "name").queryItem().arrival()
			]
		case .stop:
			guard let depStop = arr.stopDTO?.id else {
				print("fetchJourneyList","arr stop id is NIL")
				return query
			}
			query += Query.queryItems(methods: [
				Query.arrivalStopId(arrivalStopId: depStop)
			])
		}
		return query
	}
	
	
	static func addJourneyListTransfersQuery(settings : ChewSettings) -> [URLQueryItem] {
		switch settings.transferTime {
		case .direct:
			return Query.queryItems(methods: [
				Query.transfersCount(0)
			])
		case .time(minutes: let minutes):
			return Query.queryItems(methods: [
				Query.transferTime(transferTime: minutes)
			])
		}
	}
	
	static func addJourneyListTransportModes(settings : ChewSettings) -> [URLQueryItem] {
		switch settings.transportMode {
		case .all:
			return []
		case .deutschlandTicket:
			return Query.queryItems(
				methods: [
					Query.national(icTrains: false),
					Query.nationalExpress(iceTrains: false),
					Query.regionalExpress(reTrains: false),
				]
			)
		case .custom:
			let products = settings.customTransferModes
			return Query.queryItems(
				methods: [
					Query.national(icTrains: products.contains(.national)),
					Query.nationalExpress(iceTrains: products.contains(.nationalExpress)),
					Query.regionalExpress(reTrains: products.contains(.regionalExpress)),
					Query.regional(rbTrains: products.contains(.regional)),
					Query.suburban(sBahn: products.contains(.suburban)),
					Query.ferry(ferry: products.contains(.ferry)),
					Query.tram(tram: products.contains(.tram)),
					Query.taxi(taxi: products.contains(.taxi)),
					Query.subway(uBahn: products.contains(.subway))
				]
			)
		}
	}
	
	static func fetchJourneyList(dep : Stop,arr : Stop,time: Date, settings : ChewSettings) -> AnyPublisher<JourneyListDTO,ApiServiceError> {
		var query = addJourneyListStopsQuery(dep: dep, arr: arr)
		query += addJourneyListTransfersQuery(settings: settings)
		query += addJourneyListTransportModes(settings: settings)
		query += Query.queryItems(
			methods: [
				Query.departureTime(departureTime: time),
				Query.remarks(showRemarks: true),
				Query.results(max: 5),
				Query.stopovers(isShowing: true),
				Query.pretty(pretyIntend: settings.debugSettings.prettyJSON),
			]
		)
		return ApiService().fetch(JourneyListDTO.self,query: query, type: ApiService.Requests.journeys)
	}
}

