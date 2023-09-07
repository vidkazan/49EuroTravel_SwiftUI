//
//  ViewModel.swift
//  49EuroTravel
//
//  Created by Dmitrii Grigorev on 05.05.23.
//

import Foundation

class OldSearchLocationViewModel : ObservableObject {
	@Published var searchLocationDataSource : SearchLocationDataSourse
	
	var journeySearchData = JourneySearchData()
	
	var journeysData : JourneysContainer? {
		didSet {
			self.constructJourneysCollectionViewData()
		}
	}
	@Published var resultJourneysCollectionViewDataSourse : AllJourneysCollectionViewDataSourse
	
	
	init(){
		self.resultJourneysCollectionViewDataSourse = .init(journeys: [])
		self.searchLocationDataSource = .init()
	}
}

extension OldSearchLocationViewModel {
//	func updateSearchText(type : LocationDirectionType) {
//		let text : String? = {
//			switch type {
//			case .departure:
//				return searchLocationDataSource.topSearchFieldText
//			case .arrival:
//				return searchLocationDataSource.bottomSearchFieldText
//			}
//		}()
//		guard let text = text else {
//			switch type {
//			case .departure:
//				self.searchLocationDataSource.searchLocationDataDeparture = []
//			case .arrival:
//				self.searchLocationDataSource.searchLocationDataArrival = []
//			}
////			self.searchLocationDataSource.previousSearchLineString = ""
//			self.journeySearchData.clearStop(type: type)
//			return
//		}
//		if text.count > 2 {
//			self.fetchLocations(text: text,type: type)
//		} else {
//			switch type {
//			case .departure:
//				self.searchLocationDataSource.searchLocationDataDeparture = []
//			case .arrival:
//				self.searchLocationDataSource.searchLocationDataArrival = []
//			}
//			self.journeySearchData.clearStop(type: type)
//		}
//		self.searchLocationDataSource.previousSearchLineString = text
//	}
	
//	func switchStops(){
//		self.searchLocationDataSource.switchStops()
//		if journeySearchData.switchStops() == true {
//			self.getJourneys()
//		}
//	}
//	
	func updateSearchData(stop : Stop, type : LocationDirectionType){
//		switch type {
//		case .departure:
//			self.searchLocationDataSource.topSearchFieldText = stop.name ?? ""
//		case .arrival:
//			self.searchLocationDataSource.bottomSearchFieldText = stop.name ?? ""
//		}
		if journeySearchData.updateSearchStopData(type: type, stop: stop) == true {
			self.getJourneys()
		}
	}
	func updateJourneyTimeValue(date : Date){
		searchLocationDataSource.timeChooserDate = date
//		searchLocationDataSource.isShowingDatePicker = false
		if journeySearchData.updateSearchTimeData(departureTime: date) == true {
			self.getJourneys()
		}
	}
	
}
