//
//  ViewModel.swift
//  49EuroTravel
//
//  Created by Dmitrii Grigorev on 05.05.23.
//

import Foundation

struct SearchLocationDataSourse {
	var scrollOffset = CGFloat.zero
	var topSearchFieldText = ""
	var bottomSearchFieldText = ""
	var isShowingDatePicker = false
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
	var onStateChange : ((SearchControllerStates) -> Void)?
	@Published var state : SearchControllerStates {
		didSet {
			self.onStateChange?(self.state)
		}
	}
	
	var journeysData : JourneysContainer? {
		didSet {
			self.constructJourneysCollectionViewData()
		}
	}
	@Published var resultJourneysCollectionViewDataSourse : AllJourneysCollectionViewDataSourse {
		didSet {
			self.state = .onNewDataJourney
		}
	}
	
	
	init(){
		self.state = .onStart
		self.resultJourneysCollectionViewDataSourse = .init(awaitingData: false, journeys: [])
		self.searchLocationDataSource = .init()
	}
}

extension SearchLocationViewModel {
	func updateSearchText(text : String?,type : LocationDirectionType) {
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
		if journeySearchData.switchStops() == true {
			self.getJourneys()
		}
	}
	
	func updateSearchData(stop : Stop, type : LocationDirectionType){
		switch type {
		case .departure:
			self.searchLocationDataSource.topSearchFieldText = stop.name ?? ""
		case .arrival:
			self.searchLocationDataSource.bottomSearchFieldText = stop.name ?? ""
		}
		if journeySearchData.updateSearchStopData(type: type, stop: stop) == true {
			self.getJourneys()
		}
	}
	func updateJourneyTimeValue(date : Date){
		searchLocationDataSource.timeChooserDate = date
		searchLocationDataSource.isShowingDatePicker = false
		if journeySearchData.updateSearchTimeData(departureTime: date) == true {
			self.getJourneys()
		}
	}
	
}
