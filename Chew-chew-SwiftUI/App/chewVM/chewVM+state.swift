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
		var date : ChewDate
		var status : Status
		
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
		
		case editingDepartureStop
		case editingArrivalStop
		
		case sheet(SheetType)
		
		case loadingLocation
		
		
		var description : String {
			switch self {
			case .sheet:
				return "sheet"
			case .idle:
				return "idle"
			case .checkingSearchData:
				return "checkingSearchData"
			case .editingDepartureStop:
				return "editingDepartureStop"
			case .editingArrivalStop:
				return "editingArrivalStop"
			case .journeys:
				return "journeys"
			case .loadingLocation:
				return "loadingLocation"
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
		
		
		case didTapSheet(SheetType)
		
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
			case .didUpdateSettings:
				return "didUpdateSettings"
			case .didLoadInitialData:
				return "didLoadInitialData"
			case .didStartViewAppear:
				return "didStartViewAppear"
			case .didTapSheet(let type):
				return "didTapSheet \(type)"
			}
		}
	}
}
