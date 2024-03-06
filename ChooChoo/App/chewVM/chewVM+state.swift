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
		var settings : Settings
		var date : ChewDate
		var status : Status
		
		init(){
			self.depStop =  .textOnly("")
			self.arrStop = .textOnly("")
			self.settings = Settings()
			self.date = .now
			self.status = .start
		}
		init(depStop: TextFieldContent, arrStop: TextFieldContent, settings: Settings, date: ChewDate, status: Status) {
			self.depStop = depStop
			self.arrStop = arrStop
			self.settings = settings
			self.date = date
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
		case journeys(_ stops : DepartureArrivalPair)
		case editingStop(LocationDirectionType)
		case loadingLocation(send : (ChewViewModel.Event)->Void)
		
		
		var description : String {
			switch self {
			case .editingStop(let type):
				return "editingStop \(type)"
			case .idle:
				return "idle"
			case .checkingSearchData:
				return "checkingSearchData"
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
	enum Event {
		case didStartViewAppear
		case didLoadInitialData(Settings)
		case onStopEdit(LocationDirectionType)
		case onNewStop(TextFieldContent,LocationDirectionType)
		case onStopsSwitch
		case didSetBothLocations(_ stops : DepartureArrivalPair)
		case onJourneyDataUpdated(_ stops : DepartureArrivalPair)
		case onNotEnoughSearchData
		case didCancelEditStop
		case didTapCloseJourneyList
		// TODO: add type to date
//		case onNewDate(ChewDate, type: LocationDirectionType)
		case onNewDate(ChewDate)
		case didUpdateSettings(Settings)
		case didLocationButtonPressed(send : (ChewViewModel.Event)->Void)
		case didReceiveLocationData(Stop)
		case didFailToLoadLocationData
		
		var description : String {
			switch self {
			case .didCancelEditStop:
				return "didCancelEditStop"
			case .onStopEdit(let type):
				return "onStopEdit \(type)"
			case .onNotEnoughSearchData:
				return "onNotEnoughSearchData"
			case .didTapCloseJourneyList:
				return "didTapCloseJourneyList"
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
