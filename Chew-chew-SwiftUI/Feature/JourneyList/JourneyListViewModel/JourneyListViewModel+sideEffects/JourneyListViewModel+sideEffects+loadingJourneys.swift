//
//  SearchJourneyVM+feedback.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 06.09.23.
//

import Foundation
import Combine

extension JourneyListViewModel {
	func whenLoadingJourneyList() -> Feedback<State, Event> {
		Feedback {(state: State) -> AnyPublisher<Event, Never> in
			guard case .loadingJourneyList = state.status else { return Empty().eraseToAnyPublisher() }
			return self.fetchJourneyList(dep: self.depStop, arr: self.arrStop, time: self.timeChooserDate.date,settings: self.settings)
				.mapError{ $0 }
				.asyncFlatMap { data in
					let res = await constructJourneyListViewDataAsync(journeysData: data, depStop: self.depStop, arrStop: self.arrStop)
					return Event.onNewJourneyListData(
						JourneyListViewData(
							journeysViewData: res,
							data: data,
							depStop: self.depStop,
							arrStop: self.arrStop
						),
						JourneyUpdateType.initial
					)
				}
				.catch { error in Just(Event.onFailedToLoadJourneyListData(error as? ApiServiceError ?? .badRequest))}
				.eraseToAnyPublisher()
		}
	}
	
	func addJourneyListStopsQuery(dep : Stop,arr : Stop) -> [URLQueryItem] {
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
				print("fetchJourneyList","departure poi id is NIL")
				return query
			}
			
			query += Query.getQueryItems(methods: [
				Query.departurePoiId(poiId: id),
				Query.departureLatitude(departureLatitude: (String(dep.coordinates.latitude ))),
				Query.departureLongitude(departureLongitude: (String(dep.coordinates.longitude ))),
				Query.departurePoiName(poiName: "name")
			])
		case .stop:
			guard let depStop = dep.stopDTO?.id else {
				print("fetchJourneyList","departure stop id is NIL")
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
				print("fetchJourneyList","arr pointOfInterest id is NIL")
				return query
			}
			query += Query.getQueryItems(methods: [
				Query.arrivalPoiId(poiId: id),
				Query.arrivalLatitude(arrivalLatitude: (String(arr.coordinates.latitude))),
				Query.arrivalLongitude(arrivalLongitude: (String(arr.coordinates.longitude))),
				Query.arrivalPoiName(poiName: "name")
			])
		case .stop:
			guard let depStop = arr.stopDTO?.id else {
				print("fetchJourneyList","arr stop id is NIL")
				return query
			}
			query += Query.getQueryItems(methods: [
				Query.arrivalStopId(arrivalStopId: depStop)
			])
		}
		return query
	}
	
	
	func addJourneyListTransfersQuery(settings : ChewSettings) -> [URLQueryItem] {
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
	
	func addJourneyListTransportModes(settings : ChewSettings) -> [URLQueryItem] {
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
		case .custom:
			let products = settings.customTransferModes
			return Query.getQueryItems(
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
	
	func fetchJourneyList(dep : Stop,arr : Stop,time: Date, settings : ChewSettings) -> AnyPublisher<JourneyListDTO,ApiServiceError> {
		var query = addJourneyListStopsQuery(dep: dep, arr: arr)
		query += addJourneyListTransfersQuery(settings: settings)
		query += addJourneyListTransportModes(settings: settings)
		query += Query.getQueryItems(
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

