//
//  SearchLocationViewModel.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 05.09.23.
//

import Foundation
import Combine

struct SearchLocationDataSourse {
	var scrollOffset = CGFloat.zero
	var topSearchFieldText = ""
	var bottomSearchFieldText = ""
	var timeChooserDate = Date.now
	var searchLocationDataDeparture : [Stop] = []
	var searchLocationDataArrival : [Stop] = []
	var previousSearchLineString = ""
	
	mutating func switchStops(){
		swap(&topSearchFieldText, &bottomSearchFieldText)
	}
}

class SearchLocationViewModel : ObservableObject {
	@Published var searchLocationDataSource : SearchLocationDataSourse
	
	var journeySearchData = JourneySearchData()
	
	@Published var resultJourneysCollectionViewDataSourse : AllJourneysCollectionViewDataSourse
	
	
	init(){
		self.resultJourneysCollectionViewDataSourse = .init(awaitingData: false, journeys: [])
		self.searchLocationDataSource = .init()
	}
}

extension SearchLocationViewModel {
	func updateSearchText(type : LocationDirectionType) {
		let text : String? = {
			switch type {
			case .departure:
				return searchLocationDataSource.topSearchFieldText
			case .arrival:
				return searchLocationDataSource.bottomSearchFieldText
			}
		}()
		guard let text = text else {
			switch type {
			case .departure:
				self.searchLocationDataSource.searchLocationDataDeparture = []
			case .arrival:
				self.searchLocationDataSource.searchLocationDataArrival = []
			}
			self.searchLocationDataSource.previousSearchLineString = ""
			self.journeySearchData.clearStop(type: type)
			return
		}
		if text.count > 2 && text.count > self.searchLocationDataSource.previousSearchLineString.count {
			self.fetchLocations(text: text,type: type)
		} else {
			switch type {
			case .departure:
				self.searchLocationDataSource.searchLocationDataDeparture = []
			case .arrival:
				self.searchLocationDataSource.searchLocationDataArrival = []
			}
			self.journeySearchData.clearStop(type: type)
		}
		self.searchLocationDataSource.previousSearchLineString = text
	}
	
	func switchStops(){
		self.searchLocationDataSource.switchStops()
	}
	
	func updateJourneyTimeValue(date : Date){
		searchLocationDataSource.timeChooserDate = date
//		searchLocationDataSource.isShowingDatePicker = false
	}
}


extension SearchLocationViewModel {
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

