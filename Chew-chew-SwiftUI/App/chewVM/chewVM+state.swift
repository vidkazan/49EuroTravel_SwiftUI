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
		var settings : ChewSettings
		var timeChooserDate : DateType
		var status : Status
		
		init(
			depStop: Stop?,
			arrStop: Stop?,
			settings : ChewSettings,
			timeChooserDate: DateType,
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
		case loadingInitialData(viewContext: NSManagedObjectContext)
		case idle
		case editingDepartureStop
		case editingArrivalStop
		case datePicker
		case journeys(JourneyListViewModel)
		case journeyDetails(JourneyDetailsViewModel)
		case loadingLocation
		case settings
		
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
			case .settings:
				return "settings"
			case .start:
				return "start"
			case .loadingInitialData:
				return "loadingInitialData"
			}
		}
	}
	
	enum Event {
		case didStartViewAppear(NSManagedObjectContext)
		case didLoadInitialData(ChewUser?)
		
		case onDepartureEdit
		case onArrivalEdit
		case onStopsSwitch
		case didSetBothLocations(Stop,Stop)
		
		
		case onDatePickerDidPressed
		case onNewDate(DateType)
		
		case didTapSettings
		case didUpdateSettings(ChewSettings)
		
		case onNewDeparture(Stop?)
		case onNewArrival(Stop?)
		
		case didDismissBottomSheet
		
		case onJourneyDataUpdated
		
		case didLocationButtonPressed
		case didReceiveLocationData(CLLocationCoordinate2D)
		case didFailToLoadLocationData
		
		
		
		
		var description : String {
			switch self {
			case .onArrivalEdit:
				return "onArrivalEdit"
			case .onDepartureEdit:
				return "onDepartureEdit"
			case .onDatePickerDidPressed:
				return "onDatePickerDidPressed"
			case .onNewDeparture:
				return "onNewDeparture"
			case .onNewArrival:
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
