//
//  ViewDataSourse.swift
//  49EuroTravel
//
//  Created by Dmitrii Grigorev on 09.08.23.
//

import Foundation
import SwiftUI

struct BadgeDataSource : Equatable, Identifiable {
	static func == (lhs: BadgeDataSource, rhs: BadgeDataSource) -> Bool {
		lhs.name == rhs.name
	}
	
	let id = UUID()
	let style : Color?
	let name : String
	
	init(style : Color? = nil, name : String){
		self.name = name
		self.style = style
	}
}

enum Badges : Identifiable,Hashable {
	case price(price: String)
	case dticket
	case cancelled
	case connectionNotReachable
	case alertFromRemark
	
	case lineNumber(num : String)
	case legDuration(dur : Int)
	case legDirection(dir : String)
	 
	var id : Int {
		switch self {
		case .price:
			return 0
		case .dticket:
			return 1
		case .cancelled:
			return 2
		case .connectionNotReachable:
			return 3
		case .alertFromRemark:
			return 4
		case .lineNumber:
			return 5
		case .legDuration:
			return 6
		case .legDirection:
			return 7
		}
	}
	
	var badgeDataSourse : BadgeDataSource {
		switch self {
		case .price(let price):
			return BadgeDataSource(
				style: Color(hue: 0.5, saturation: 1, brightness: 0.4),
				name: price)
		case .dticket:
			return BadgeDataSource(
				style: Color(hue: 0.35, saturation: 0, brightness: 0.6),
				name: "DeutschlandTicket")
		case .cancelled:
			return BadgeDataSource(
				style: Color(hue: 0, saturation: 1, brightness: 0.7),
				name: "cancelled")
		case .connectionNotReachable:
			return BadgeDataSource(
				style: Color(hue: 0, saturation: 1, brightness: 0.7),
				name: "not reachable")
		case .alertFromRemark:
			return BadgeDataSource(
				style: Color(hue: 0, saturation: 1, brightness: 0.7),
				name: " ! ")
		case .lineNumber(num: let num):
			return BadgeDataSource(
				name: num)
		case .legDuration(dur: let dur):
			return BadgeDataSource(name: DateParcer.getTimeStringWithHoursAndMinutesFormat(minutes: dur) ?? "duration")
		case .legDirection(dir: let dir):
			return BadgeDataSource(name: dir)
		}
	}
}

struct TimelineTimeLabelDataSourse : Equatable,Hashable {
	let text : String
	let textCenterYposition : Double
}

struct TimelineViewDataSourse : Equatable,Hashable {
	let timeLabels : [TimelineTimeLabelDataSourse]
}

struct LegViewDataSourse : Equatable,Identifiable,Hashable {
	let id : Int
	let name : String
	let legTopPosition : Double
	let legBottomPosition : Double
	var delayedAndNextIsNotReachable : Bool?
	let remarks : [Remark]?
}

struct JourneyCollectionViewDataSourse : Equatable {
	let id : UUID
	let startPlannedTimeDate : Date
	let startActualTimeDate : Date
	let endPlannedTimeDate : Date
	let endActualTimeDate : Date
	let startDate : Date
	let endDate : Date
	let durationLabelText : String
	let legDTO : [Leg]?
	let legs : [LegViewDataSourse]
	let sunEvents : [SunEvent]
	let isReachable : Bool
	let badges : [Badges]
	let refreshToken : String?
}

struct JourneyViewDataSourse : Equatable,Hashable {
	let legs : [LegViewDataSourse]
}

struct AllJourneysCollectionViewDataSourse : Equatable{
	let journeys : [JourneyCollectionViewDataSourse]
}

struct ResultJourneyViewDataSourse : Equatable,Hashable {
	let journeys : [JourneyViewDataSourse]?
	let timeline : TimelineViewDataSourse?
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
