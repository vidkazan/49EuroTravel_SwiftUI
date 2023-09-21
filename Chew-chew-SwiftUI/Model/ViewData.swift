//
//  ViewData.swift
//  49EuroTravel
//
//  Created by Dmitrii Grigorev on 09.08.23.
//

import Foundation
import SwiftUI

struct JourneyDetailsViewData : Equatable,Identifiable,Hashable {
	struct LegDetailsViewData : Equatable,Identifiable,Hashable {
		let id = UUID()
	}
	let id = UUID()
	let legsViewData : [LegViewData]
}

enum Badges : Identifiable,Hashable {
	
	struct BadgeData : Equatable, Identifiable {
		static func == (lhs: BadgeData, rhs: BadgeData) -> Bool {
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
	
	var badgeData : BadgeData {
		switch self {
		case .price(let price):
			return BadgeData(
				style: Color(hue: 0.5, saturation: 1, brightness: 0.4),
				name: price)
		case .dticket:
			return BadgeData(
				style: Color(hue: 0.35, saturation: 0, brightness: 0.6),
				name: "DeutschlandTicket")
		case .cancelled:
			return BadgeData(
				style: Color(hue: 0, saturation: 1, brightness: 0.7),
				name: "cancelled")
		case .connectionNotReachable:
			return BadgeData(
				style: Color(hue: 0, saturation: 1, brightness: 0.7),
				name: "not reachable")
		case .alertFromRemark:
			return BadgeData(
				style: Color(hue: 0, saturation: 1, brightness: 0.7),
				name: " ! ")
		case .lineNumber(num: let num):
			return BadgeData(
				name: num)
		case .legDuration(dur: let dur):
			return BadgeData(name: DateParcer.getTimeStringWithHoursAndMinutesFormat(minutes: dur) ?? "duration")
		case .legDirection(dir: let dir):
			return BadgeData(name: dir)
		}
	}
}

struct TimelineTimeLabelData : Equatable,Hashable {
	let text : String
	let textCenterYposition : Double
}

struct LegViewData : Equatable,Identifiable,Hashable {
	let id : Int
	let name : String
	let legTopPosition : Double
	let legBottomPosition : Double
	var delayedAndNextIsNotReachable : Bool?
	let remarks : [Remark]?
}

struct JourneyCollectionViewData : Equatable {
	let id : UUID
	let startPlannedTimeDate : Date
	let startActualTimeDate : Date
	let endPlannedTimeDate : Date
	let endActualTimeDate : Date
	let startDate : Date
	let endDate : Date
	let durationLabelText : String
	let legDTO : [Leg]?
	let legs : [LegViewData]
	let sunEvents : [SunEvent]
	let isReachable : Bool
	let badges : [Badges]
	let refreshToken : String?
}

struct ResultJourneyViewData : Equatable,Hashable {
	let journeys : [[LegViewData]]?
	let timeline : [TimelineTimeLabelData]?
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
