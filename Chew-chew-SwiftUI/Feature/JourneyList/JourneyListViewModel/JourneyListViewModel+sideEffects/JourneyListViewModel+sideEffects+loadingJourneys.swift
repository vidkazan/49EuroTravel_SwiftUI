//
//  SearchJourneyVM+feedback.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 06.09.23.
//

import Foundation
import Combine

extension JourneyListViewModel {
	func whenLoadingJourneys() -> Feedback<State, Event> {
	  Feedback {(state: State) -> AnyPublisher<Event, Never> in
		  guard case .loadingJourneys = state.status else { return Empty().eraseToAnyPublisher() }
		  return self.fetchJourneys(dep: self.depStop, arr: self.arrStop, time: self.timeChooserDate.date)
			  .map({data in JourneysViewData.init(data: data, depStop: self.depStop, arrStop: self.arrStop)})
			  .map {Event.onNewJourneysData($0,.initial)}
			  .catch { error in Just(.onFailedToLoadJourneysData(error))}
			  .eraseToAnyPublisher()
	  }
	}
	func addJourneysStopsQuery(dep : StopType,arr : StopType) -> [URLQueryItem] {
		var query : [URLQueryItem] = []
		switch dep {
		case .location(let stop):
			query += Query.getQueryItems(methods: [
				Query.departureAddress(addr: "My Location"),
				Query.departureLatitude(departureLatitude: (stop.location?.latitude?.description ?? "")),
				Query.departureLongitude(departureLongitude: (stop.location?.longitude?.description ?? ""))
			])
		case .pointOfInterest(let stop):
			guard let id = stop.id else {
				print("fetchJourneys","departure poi id is NIL")
				return query
			}
			query += Query.getQueryItems(methods: [
				Query.departurePoiId(poiId: id),
				Query.departureLatitude(departureLatitude: (stop.location?.latitude?.description ?? "")),
				Query.departureLongitude(departureLongitude: (stop.location?.longitude?.description ?? ""))
			])
		case .stop(let stop):
			guard let depStop = stop.id else {
				print("fetchJourneys","departure stop id is NIL")
				return query
			}
			query += Query.getQueryItems(methods: [
				Query.departureStopId(departureStopId: depStop)
			])
		}
		
		switch arr {
		case .location(let stop):
			query += Query.getQueryItems(methods: [
				Query.arrivalAddress(addr: "My Location"),
				Query.arrivalLatitude(arrivalLatitude: (stop.location?.latitude?.description ?? "")),
				Query.arrivalLongitude(arrivalLongitude: (stop.location?.longitude?.description ?? ""))
			])
		case .pointOfInterest(let stop):
			guard let id = stop.id else {
				print("fetchJourneys","arr pointOfInterest id is NIL")
				return query
			}
			query += Query.getQueryItems(methods: [
				Query.arrivalPoiId(poiId: id),
				Query.arrivalLatitude(arrivalLatitude: (stop.location?.latitude?.description ?? "")),
				Query.arrivalLongitude(arrivalLongitude: (stop.location?.longitude?.description ?? ""))
			])
		case .stop(let stop):
			guard let depStop = stop.id else {
				print("fetchJourneys","arr stop id is NIL")
				return query
			}
			query += Query.getQueryItems(methods: [
				Query.arrivalStopId(arrivalStopId: depStop)
			])
		}
		return query
	}
	
	func fetchJourneys(dep : StopType,arr : StopType,time: Date) -> AnyPublisher<JourneysContainer,ApiServiceError> {
		var query = addJourneysStopsQuery(dep: dep, arr: arr)
		query += Query.getQueryItems(methods: [
			Query.departureTime(departureTime: time),
			Query.national(icTrains: false),
			Query.nationalExpress(iceTrains: false),
			Query.regionalExpress(reTrains: false),
//			Query.pretty(pretyIntend: false),
			Query.taxi(taxi: false),
			Query.remarks(showRemarks: true),
			Query.results(max: 5),
//			Query.stopovers(isShowing: true)
		])
		return ApiService.fetchCombine(JourneysContainer.self,query: query, type: ApiService.Requests.journeys, requestGroupId: "")
	}
}

