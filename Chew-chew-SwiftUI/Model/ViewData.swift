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
		let departureDelay,
			arrivalDelay		: Int
		let timeContainer : TimeContainer
		
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
	let footDistance : Int
	let lineName : String
}

enum FootLegPlace : Equatable, Hashable {
	case atStart(startPointName : String)
	case inBetween
	case atFinish(finishPointName : String)
}
enum LegType : Equatable,Hashable {
	case foot(place : FootLegPlace)
	case transfer
	case line
	
	var description : String {
		switch self {
		case .line:
			return "line"
		case .foot:
			return "foot"
		case .transfer:
			return "transfer"
		}
	}
}
struct JourneyViewData : Equatable {
	let id : UUID
	let origin : String
	let destination : String
	let startPlannedTimeString : String
	let startActualTimeString : String
	let endPlannedTimeString : String
	let endActualTimeString : String
	let startDelay : Int
	let endDelay : Int
	let startDate : Date
	let endDate : Date
	let startDateString : String
	let endDateString : String
	let durationLabelText : String
	let legs : [LegViewData]
	let transferCount : Int
	let sunEvents : [SunEvent]
	let isReachable : Bool
	let badges : [Badges]
	let refreshToken : String?
}

enum LocationDirectionType :Int, Hashable {
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
