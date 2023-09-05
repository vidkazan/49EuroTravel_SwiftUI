//
//  ViewModel+Fetch.swift
//  49EuroTravel
//
//  Created by Dmitrii Grigorev on 09.08.23.
//

import Foundation
import Combine

extension SearchLocationViewModel {
	func getJourneys(){
		self.resultJourneysCollectionViewDataSourse = AllJourneysCollectionViewDataSourse(awaitingData: true, journeys: [])
		self.fetchJourneys()
	}
	
	private func fetchJourneys(){
			var query : [URLQueryItem] = []
			query = Query.getQueryItems(methods: [
				Query.departureTime(departureTime: self.journeySearchData.departureTime),
				Query.departureStop(departureStopId: self.journeySearchData.departureStop?.stop.id),
				Query.arrivalStop(arrivalStopId: self.journeySearchData.arrivalStop?.stop.id),
				Query.national(icTrains: false),
				Query.nationalExpress(iceTrains: false),
				Query.regionalExpress(reTrains: false),
				Query.pretty(pretyIntend: false),
				Query.taxi(taxi: false),
				Query.remarks(showRemarks: true),
				Query.results(max: 5)
			])
		ApiService.fetch(JourneysContainer.self,query: query, type: ApiService.Requests.journeys,requestGroupId: "") { [self] result in
				switch result {
				case .success(let res) :
					self.journeysData = res
				case .failure(_) :
					break
				}
			}
		}
	
	func fetchLocations(text : String?, type : LocationDirectionType){
		guard let text = text else { return }
		if text.count < 2 { return }
		var query : [URLQueryItem] = []
		query = Query.getQueryItems(methods: [
			Query.location(location: text),
			Query.results(max: 5)
		])
		ApiService.fetch([Stop].self,query: query, type: ApiService.Requests.locations(name: text ),requestGroupId: "") { [self] result in
			switch result {
			case .success(let res) :
				switch type {
				case .departure:
					self.searchLocationDataSource.searchLocationDataDeparture = res
				case .arrival:
					self.searchLocationDataSource.searchLocationDataArrival = res
				}
			case .failure(_) :
				break
			}
		}
	}
	
	static func fetchLocationsCombine(text : String, type : LocationDirectionType) -> AnyPublisher<[Stop],Error> {
		var query : [URLQueryItem] = []
		query = Query.getQueryItems(methods: [
			Query.location(location: text),
			Query.results(max: 5)
		])
		return ApiService.fetchCombine([Stop].self,query: query, type: ApiService.Requests.locations(name: text ), requestGroupId: "")
	}
}
