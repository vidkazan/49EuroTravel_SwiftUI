//
//  +state.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.09.23.
//

import Foundation
import CoreLocation

extension ChewViewModel {
	enum DateType : Equatable,Hashable {
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
		
		init(
			depStop: Stop?,
			arrStop: Stop?,
			timeChooserDate: DateType,
			status: Status
		) {
			self.depStop = depStop
			self.arrStop = arrStop
			self.timeChooserDate = timeChooserDate
			self.status = status
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
		case loadingLocation
		
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
			case .loadingLocation:
				return "loadingLocation"
			}
		}
	}
	
	enum Event {
		case onDepartureEdit
		case onArrivalEdit
		case onDatePickerDidPressed
		case onNewDeparture(Stop?)
		case onNewArrival(Stop?)
		case onStopsSwitch
		case onNewDate(DateType)
		case onJourneyDataUpdated
		case didLocationButtonPressed
		case didReceiveLocationData(CLLocationCoordinate2D)
		case didFailToLoadLocationData
		case didSetBothLocations(Stop,Stop)
		case didDismissDatePicker
		
		
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
			case .onStopsSwitch:
				return "onStopsSwitch"
			case .onNewDate:
				return "onNewDate"
			case .onJourneyDataUpdated:
				return "onJourneyDataUpdated"
			case .didReceiveLocationData:
				return "didReceiveLocaitonData"
			case .didFailToLoadLocationData:
				return "didFailToLoadLocationData"
			case .didLocationButtonPressed:
				return "didLocationButtonPressed"
			case .didSetBothLocations:
				return "didSetBothLocations"
			case .didDismissDatePicker:
				return "didDismissDatePicker"
			}
		}
	}
}
