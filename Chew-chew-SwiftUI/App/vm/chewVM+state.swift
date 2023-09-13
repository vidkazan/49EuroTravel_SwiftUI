//
//  +state.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.09.23.
//

import Foundation

extension ChewViewModel {
	enum DateType :  Equatable {
		case now
		case specificDate(Date)
		
		var date : Date {
			switch self{
			case .now:
				return .now
			case .specificDate(let date):
				return date
			}
		}
	}
	
	struct State : Equatable {
		var depStop : Stop?
		var arrStop : Stop?
		var timeChooserDate : DateType
		var status : Status
		let searchStopViewModel : SearchLocationViewModel
		
		init(
			depStop: Stop?,
			arrStop: Stop?,
			timeChooserDate: DateType,
			status: Status,
			searchStopViewModel: SearchLocationViewModel = .init(type: .departure)
		) {
			self.depStop = depStop
			self.arrStop = arrStop
			self.timeChooserDate = timeChooserDate
			self.status = status
			self.searchStopViewModel = searchStopViewModel
		}
	}
	
	
	enum Status : Equatable {
		static func == (lhs: ChewViewModel.Status, rhs: ChewViewModel.Status) -> Bool {
			return lhs.description == rhs.description
		}
		
		case idle
		case editingDepartureStop
		case editingArrivalStop
		case datePicker
		case journeys(JourneyListViewModel)
		case journeyDetails(JourneyDetailsViewModel)
		
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
			case .journeys:
				return "journeys"
			case .journeyDetails:
				return "journeyDetails"
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
		case onNewDate(DateType)
		case onJourneyDataUpdated
		case onBackFromJourneyDetails
		
		
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
			case .onBackFromJourneyDetails:
				return "onBackFromJourneyDetails"
			}
		}
	}
}
