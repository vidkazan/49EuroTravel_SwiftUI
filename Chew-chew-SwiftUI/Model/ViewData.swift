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
		init(name : String,timeContainer : TimeContainer) {
			self.timeContainer = timeContainer
			self.departurePlannedTimeString = DateParcer.getTimeStringFromDate(date: timeContainer.date.plannedDeparture) ?? "time0"
			self.departureActualTimeString = DateParcer.getTimeStringFromDate(date: timeContainer.date.actualDeparture) ?? "time0"
			self.arrivalPlannedTimeString = DateParcer.getTimeStringFromDate(date: timeContainer.date.plannedArrival) ?? "time0"
			self.arrivalActualTimeString = DateParcer.getTimeStringFromDate(date: timeContainer.date.actualArrival) ?? "time0"
			self.name = name
			self.departurePlatform = ""
			self.plannedDeparturePlatform = ""
			self.arrivalPlatform = ""
			self.plannedArrivalPlatform = ""
			self.departureDelay = 0
			self.arrivalDelay = 0
		}
		init(name : String,timeContainer : TimeContainer, stop : StopOver) {
			self.timeContainer = timeContainer
			self.departurePlannedTimeString = DateParcer.getTimeStringFromDate(date: timeContainer.date.plannedDeparture) ?? "time1"
			self.departureActualTimeString = DateParcer.getTimeStringFromDate(date: timeContainer.date.actualDeparture) ?? "time1"
			self.arrivalPlannedTimeString = DateParcer.getTimeStringFromDate(date: timeContainer.date.plannedArrival) ?? "time1"
			self.arrivalActualTimeString = DateParcer.getTimeStringFromDate(date: timeContainer.date.actualArrival) ?? "time1"
			self.name = name
			self.departurePlatform = stop.departurePlatform
			self.plannedDeparturePlatform = stop.plannedDeparturePlatform
			self.arrivalPlatform = stop.arrivalPlatform
			self.plannedArrivalPlatform = stop.plannedArrivalPlatform
			self.departureDelay = stop.departureDelay ?? 0
			self.arrivalDelay = stop.arrivalDelay ?? 0
		}
		init(name : String,timeContainer : TimeContainer, leg : Leg) {
			self.timeContainer = timeContainer
			self.departurePlannedTimeString = DateParcer.getTimeStringFromDate(date: timeContainer.date.plannedDeparture) ?? "time2"
			self.departureActualTimeString = DateParcer.getTimeStringFromDate(date: timeContainer.date.actualDeparture) ?? "time2"
			self.arrivalPlannedTimeString = DateParcer.getTimeStringFromDate(date: timeContainer.date.plannedArrival) ?? "time2"
			self.arrivalActualTimeString = DateParcer.getTimeStringFromDate(date: timeContainer.date.actualArrival) ?? "time2"
			self.name = name
			self.departurePlatform = leg.departurePlatform
			self.plannedDeparturePlatform = leg.plannedDeparturePlatform
			self.arrivalPlatform = leg.arrivalPlatform
			self.plannedArrivalPlatform = leg.plannedArrivalPlatform
			self.departureDelay = leg.departureDelay ?? 0
			self.arrivalDelay = leg.arrivalDelay ?? 0
			
		}
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
	case footStart(startPointName : String)
	case footMiddle
	case footEnd(finishPointName : String)
	case transfer
	case line
	
	var description : String {
		switch self {
		case .line:
			return "line"
		case .transfer:
			return "transfer"
		case .footStart:
			return "footStart"
		case .footMiddle:
			return "footMiddle"
		case .footEnd:
			return "footEnd"
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
