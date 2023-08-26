//
//  ViewModel.swift
//  49EuroTravel
//
//  Created by Dmitrii Grigorev on 05.05.23.
//

import Foundation

class SearchLocationViewModel : ObservableObject {
	
	@Published var isShowingDatePicker = false
	@Published var timeChooserDate = Date.now
	var journeySearchData = JourneySearchData()
	var onStateChange : ((SearchControllerStates) -> Void)?
	@Published var state : SearchControllerStates {
		didSet {
			self.onStateChange?(self.state)
		}
	}
	@Published var searchLocationDataDeparture : [Stop] = []  {
		didSet {
			self.state = .onNewDataDepartureStop
		}
	}
	@Published var searchLocationDataArrival : [Stop] = []  {
		didSet {
			self.state = .onNewDataArrivalStop
		}
	}
	var journeysData : JourneysContainer? {
		didSet {
			self.constructJourneysCollectionViewData()
		}
	}
//	var resultJourneysViewDataSourse : AllJourneysCollectionViewDataSourse? {
//		didSet {
//			self.state = .onNewDataJourney
//		}
//	}
	@Published var resultJourneysCollectionViewDataSourse : AllJourneysCollectionViewDataSourse {
		didSet {
			self.state = .onNewDataJourney
		}
	}
	var previousSearchLineString = ""
	
	init(){
		self.state = .onStart
		self.resultJourneysCollectionViewDataSourse = AllJourneysCollectionViewDataSourse(awaitingData: false, journeys: [])
	}
}

extension SearchLocationViewModel {
	func updateSearchText(text : String?,type : LocationDirectionType){
		guard let text = text else {
			switch type {
			case .departure:
				self.searchLocationDataDeparture = []
			case .arrival:
				self.searchLocationDataArrival = []
			}
			self.previousSearchLineString = ""
			return
		}
		if text.count > 2 && text.count > self.previousSearchLineString.count {
			self.fetchLocations(text: text,type: type)
		} else {
			switch type {
			case .departure:
				self.searchLocationDataDeparture = []
			case .arrival:
				self.searchLocationDataArrival = []
			}
		}
		self.previousSearchLineString = text
	}
	
	func updateSearchData(stop : Stop, type : LocationDirectionType){
		if journeySearchData.updateSearchStopData(type: type, stop: stop) == true {
//			self.resultJourneysViewDataSourse = ResultJourneyViewDataSourse(
//				awaitingData: true,
//				journeys: nil,
//				timeline: nil)
			self.fetchJourneys()
		}
	}
	func updateJourneyTimeValue(date : Date){
		print(date)
		timeChooserDate = date
		isShowingDatePicker = false
		if journeySearchData.updateSearchTimeData(departureTime: date) == true {
//			self.resultJourneysViewDataSourse = ResultJourneyViewDataSourse(
//				awaitingData: true,
//				journeys: nil,
//				timeline: nil)
			self.fetchJourneys()
		}
	}
}
