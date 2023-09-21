//
//  ViewData.swift
//  49EuroTravel
//
//  Created by Dmitrii Grigorev on 09.08.23.
//

import Foundation
import SwiftUI



struct TimelineTimeLabelData : Equatable,Hashable {
	let text : String
	let textCenterYposition : Double
}

struct LegViewData : Equatable,Identifiable,Hashable {
	enum LegType : Equatable,Hashable {
		case foot(distance: Int)
		case bus(name: String)
		case train(name : String)
		case custom(name: String)
		
		var description : String {
			switch self {
			case .bus(name: let name):
				return "bus" + name
			case .foot(distance: let distance):
				return "foot " + String(distance) + "m"
			case .train(name: let name):
				return "train" + name
			case .custom(name: let name):
				return "custom " + name
			}
		}
		
		var value : String {
			switch self {
			case .bus(name: let name):
				return name
			case .foot(distance: let distance):
				return String(distance) + "m"
			case .train(name: let name):
				return name
			case .custom(name: let name):
				return name
			}
		}
	}
	struct StopViewData : Equatable,Identifiable,Hashable {
		let id = UUID()
		let name : String
		let departurePlannedTimeString : String
		let departureActualTimeString : String
		let arrivalPlannedTimeString : String
		let arrivalActualTimeString : String
		let departurePlatform,
			plannedDeparturePlatform	: String?
		let arrivalPlatform,
			plannedArrivalPlatform	: String?
	}
	let id : Int
	let fillColor : Color
	let legType : LegType
	let direction : String
	let duration : String
	let legTopPosition : Double
	let legBottomPosition : Double
	var delayedAndNextIsNotReachable : Bool?
	let remarks : [Remark]?
	let legStopsViewData : [StopViewData]
}

struct JourneyViewData : Equatable {
	let id : UUID
	let origin : String
	let destination : String
	let startPlannedTimeString : String
	let startActualTimeString : String
	let endPlannedTimeString : String
	let endActualTimeString : String
	let startDate : Date
	let endDate : Date
	let startDateString : String
	let endDateString : String
	let durationLabelText : String
	let legDTO : [Leg]?
	let legs : [LegViewData]
	let sunEvents : [SunEvent]
	let isReachable : Bool
	let badges : [Badges]
	let refreshToken : String?
}

enum LocationDirectionType :Equatable, Hashable {
	case departure
	case arrival
	
	var placeholder : String {
		switch self {
		case .departure:
			return "from"
		case .arrival:
			return "to"
		}
	}
}
