//
//  SearchJourneyVM+state.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 06.09.23.
//

import Foundation

extension SearchJourneyViewModel {
	struct State {
		var depStop : Stop?
		var arrStop : Stop?
		var timeChooserDate : Date
		var journeys : [JourneyCollectionViewDataSourse]
		var status : Status
		let searchStopViewModel : SearchLocationViewModel
		
		init(
			depStop: Stop? = nil,
			arrStop: Stop? = nil,
			timeChooserDate: Date,
			journeys: [JourneyCollectionViewDataSourse],
			status: Status,
			searchStopViewModel: SearchLocationViewModel = .init(type: .departure)
		) {
			self.depStop = depStop
			self.arrStop = arrStop
			self.timeChooserDate = timeChooserDate
			self.journeys = journeys
			self.status = status
			self.searchStopViewModel = searchStopViewModel
		}
	}
	
	
	enum Status : Equatable {
		static func == (lhs: SearchJourneyViewModel.Status, rhs: SearchJourneyViewModel.Status) -> Bool {
			return lhs.description == rhs.description
		}
		
		case idle
		case editingDepartureStop
		case editingArrivalStop
		case datePicker
		case loadingJourneys
		case journeysLoaded
		case failedToLoadJourneys
		case journeyDetails
		
		var description : String {
			switch self {
			case .idle:
				return "idle"
			case .editingDepartureStop:
				return "editingDepartureStop"
			case .editingArrivalStop:
				return "editingArrivalStop"
			case .datePicker:
				return "datePicker"
			case .loadingJourneys:
				return "loadingJourneys"
			case .journeyDetails:
				return "journeyDetails"
			case .failedToLoadJourneys:
				return "failedToLoadJourneys"
			case .journeysLoaded:
				return "journeysLoaded"
			}
		}
	}
	
	enum Event {
		case onDepartureEdit
		case onArrivalEdit
		case onDatePickerDidPressed
		case onNewDeparture(Stop?)
		case onNewArrival(Stop?)
		case onResetJourneyView
		case onStopsSwitch
		case onNewDate(Date)
		case onJourneyDataUpdated
		case onNewJourneysData(JourneysContainer)
		case onFailedToLoadJourneysData(ApiServiceError)
		case onJourneyDidPressed
		case onBackFromJourneyDetails
		case onReloadJourneys
		case onLaterRef
		case onEarlierRef
		
		var description : String {
			switch self {
			case .onArrivalEdit:
				return "onArrivalEdit"
			case .onDepartureEdit:
				return "onDepartureEdit"
			case .onDatePickerDidPressed:
				return "onDatePickerDidPressed"
			case .onNewDeparture(_):
				return "onNewDeparture"
			case .onNewArrival(_):
				return "onNewArrival"
			case .onResetJourneyView:
				return "onResetJourneyView"
			case .onStopsSwitch:
				return "onStopsSwitch"
			case .onNewDate:
				return "onNewDate"
			case .onJourneyDataUpdated:
				return "onJourneyDataUpdated"
			case .onNewJourneysData(_):
				return "onNewJourneysData"
			case .onFailedToLoadJourneysData(_):
				return "onFailedToLoadJourneysData"
			case .onJourneyDidPressed:
				return "onJourneyDidPressed"
			case .onBackFromJourneyDetails:
				return "onBackFromJourneyDetails"
			case .onReloadJourneys:
				return "onReloadJourneys"
			case .onLaterRef:
				return "onLaterRef"
			case .onEarlierRef:
				return "onEarlierRef"
			}
		}
	}
}
