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
		  return self.fetchJourneys(dep: self.depStop, arr: self.arrStop, time: self.timeChooserDate.date)
			  .mapError{ $0 }
			  .asyncFlatMap { data in
				  let res = await constructJourneysViewDataAsync(journeysData: data, depStop: self.depStop, arrStop: self.arrStop)
				  return Event.onNewJourneysData(JourneysViewData(journeysViewData: res, data: data, depStop: self.depStop, arrStop: self.arrStop),.initial)
			  }
			  .catch { error in Just(Event.onFailedToLoadJourneysData(.badRequest))}
			  .eraseToAnyPublisher()
	  }
	}
	
	// TODO: duplicating code
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
	
	func fetchJourneys(dep : Stop,arr : Stop,time: Date) -> AnyPublisher<JourneysContainer,ApiServiceError> {
		var query = addJourneysStopsQuery(dep: dep, arr: arr)
		query += Query.getQueryItems(methods: [
			Query.departureTime(departureTime: time),
			Query.national(icTrains: false),
			Query.nationalExpress(iceTrains: false),
			Query.regionalExpress(reTrains: false),
			Query.taxi(taxi: false),
			Query.remarks(showRemarks: true),
			Query.results(max: 5),
			Query.stopovers(isShowing: true),
			Query.pretty(pretyIntend: false),
			Query.transferTime(transferTime: 1)
		])
		return ApiService.fetchCombine(JourneysContainer.self,query: query, type: ApiService.Requests.journeys, requestGroupId: "")
	}
}

