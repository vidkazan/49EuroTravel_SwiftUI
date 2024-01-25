//
//  +state.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.09.23.
//

import Foundation
import CoreLocation
import CoreData

extension ChewViewModel {
	enum ChewDate : Equatable,Hashable {
		case now
		case specificDate(Date)
		
		var date : Date {
			switch self {
			case .now:
				return .now
			case .specificDate(let date):
				return date
			}
		}
	}
	
	enum TextFieldContent : Equatable,Hashable {
		case textOnly(String)
		case location(Stop)
		
		var text : String {
			switch self {
			case .textOnly(let text):
				return text
			case .location(let stop):
				return stop.name
			}
		}
		
		var stop : Stop? {
			switch self {
			case .textOnly:
				return nil
			case .location(let stop):
				return stop
			}
		}
	}
	
	struct State : Equatable {
		var depStop : TextFieldContent
		var arrStop : TextFieldContent
		var settings : ChewSettings
		var timeChooserDate : ChewDate
		var status : Status
		
		init(
			depStop: TextFieldContent,
			arrStop: TextFieldContent,
			settings : ChewSettings,
			timeChooserDate: ChewDate,
			status: Status
		) {
			self.depStop = depStop
			self.arrStop = arrStop
			self.settings = settings
			self.timeChooserDate = timeChooserDate
			self.status = status
		}
	}
	
	
	enum Status : Equatable {
		static func == (lhs: ChewViewModel.Status, rhs: ChewViewModel.Status) -> Bool {
			return lhs.description == rhs.description
		}
		
		case start
		case loadingInitialData
		case idle
		
		case checkingSearchData
		case journeys(JourneyListViewModel)
		case journeyDetails(JourneyDetailsViewModel)
		
		case editingDepartureStop
		case editingArrivalStop
		case settings
		case datePicker
		
		case loadingLocation
		
		
		var description : String {
			switch self {
			case .idle:
				return "idle"
			case .checkingSearchData:
				return "checkingSearchData"
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
			case .settings:
				return "settings"
			case .start:
				return "start"
			case .loadingInitialData:
				return "loadingInitialData"
			}
		}
	}
	
	enum SheetType {
		case settings
		case date
	}
	enum Event {
		case didStartViewAppear
		case didLoadInitialData(ChewSettings)
		
		
		case onDepartureEdit
		case onArrivalEdit
		case onStopsSwitch
		
		
		
		case onNotEnoughSearchData
		case didTapCloseJourneyList
		
		
		case didSetBothLocations(Stop,Stop)
		case onNewStop(TextFieldContent,LocationDirectionType)
		
		case onJourneyDataUpdated(depStop: Stop, arrStop : Stop)
		
		
//		case didTapSheet(SheetType)
		case didTapDatePicker
		case didTapSettings
		
		case onNewDate(ChewDate)
		
		case didUpdateSettings(ChewSettings)
		case didDismissBottomSheet
		
		
		case didLocationButtonPressed
		case didReceiveLocationData(CLLocationCoordinate2D)
		case didFailToLoadLocationData
		
		var description : String {
			switch self {
			case .onNotEnoughSearchData:
				return "onNotEnoughSearchData"
			case .didTapCloseJourneyList:
				return "didTapCloseJourneyList"
			case .onArrivalEdit:
				return "onArrivalEdit"
			case .onDepartureEdit:
				return "onDepartureEdit"
			case .didTapDatePicker:
				return "onDatePickerDidPressed"
			case .onNewStop:
				return "onNewStop"
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
			case .didDismissBottomSheet:
				return "didDismissBottomSheet"
			case .didTapSettings:
				return "didTapSettings"
			case .didUpdateSettings:
				return "didUpdateSettings"
			case .didLoadInitialData:
				return "didLoadInitialData"
			case .didStartViewAppear:
				return "didStartViewAppear"
			}
		}
	}
}
