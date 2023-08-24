//
//  ViewModel.swift
//  49EuroTravel
//
//  Created by Dmitrii Grigorev on 05.05.23.
//

import Foundation

class SearchLocationViewModel : ObservableObject {
	
	@Published var isShowingDatePicker = false
	var journeySearchData = JourneySearchData()
	var onStateChange : ((SearchControllerStates) -> Void)?
	var state : SearchControllerStates {
		didSet {
			self.onStateChange?(self.state)
		}
	}
	var searchLocationDataDeparture : [Stop] = []  {
		didSet {
			self.state = .onNewDataDepartureStop
		}
	}
	var searchLocationDataArrival : [Stop] = []  {
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
	var resultJourneysCollectionViewDataSourse : AllJourneysCollectionViewDataSourse {
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
	func updateSearchText(text : String?,isDeparture : Bool){
		guard let text = text else { return }
		if text.count > 2 && text.count > self.previousSearchLineString.count {
			self.fetchLocations(text: text,isDeparture : isDeparture)
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
	func updateJourneyTimeValue(date : Date?){
		if journeySearchData.updateSearchTimeData(departureTime: date) == true {
//			self.resultJourneysViewDataSourse = ResultJourneyViewDataSourse(
//				awaitingData: true,
//				journeys: nil,
//				timeline: nil)
			self.fetchJourneys()
		}
	}
}
