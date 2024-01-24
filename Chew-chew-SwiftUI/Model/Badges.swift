//
//  Badges.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 21.09.23.
//

import Foundation
import SwiftUI

struct BadgeData : Equatable {
	static func == (lhs: BadgeData, rhs: BadgeData) -> Bool {
		lhs.name == rhs.name
	}
	
	var style : Color = Color.chewFillTertiary
	let name : String
	
	init(style : Color, name : String){
		self.init(name: name)
		self.style = style
	}
	init(style : Color){
		self.init()
		self.style = style
	}
	init(name : String){
		self.name = name
	}
	init(){
		self.name = "BadgeName"
	}
}

enum StopsCountBadgeMode {
	case hideShevron
	case showShevronUp
	case showShevronDown
	
	var angle : Double {
		switch self {
		case .hideShevron:
			return 0
		case .showShevronUp:
			return 0
		case .showShevronDown:
			return 180
		}
	}
}

enum Badges : Hashable {
	case failedToGetUserLocation
	case offlineMode
	case departureArrivalStops(departure: String,arrival: String)
	case changesCount(_ count : Int)
	case timeDepartureTimeArrival(timeDeparture: String,timeArrival: String)
	case date(dateString : String)
	case price(_ price: String)
	case dticket
	case cancelled
	case connectionNotReachable
	case alertFromRemark
	
	case lineNumber(lineType:LineType,num : String)
	case stopsCount(_ count : Int,_ mode : StopsCountBadgeMode)
	case legDuration(dur : String)
	case legDirection(dir : String)
	case walking(duration : String)
	case transfer(duration : String)
	
	case updatedAtTime(referenceTime : Double, isLoading : Bool = false)
	
	var badgeDefaultStyle : BadgeBackgroundBaseStyle {
		switch self {
		case .failedToGetUserLocation:
			return .primary
		case .offlineMode:
			return .primary
		case .departureArrivalStops:
			return .primary
		case .changesCount:
			return .primary
		case .timeDepartureTimeArrival:
			return .primary
		case .date:
			return .primary
		case .price:
			return .primary
		case .dticket:
			return .primary
		case .cancelled:
			return .red
		case .connectionNotReachable:
			return .red
		case .alertFromRemark:
			return .red	
		case .lineNumber:
			return .primary
		case .stopsCount:
			return .primary
		case .legDuration:
			return .primary
		case .legDirection:
			return .primary
		case .walking:
			return .primary
		case .transfer:
			return .primary
		case .updatedAtTime:
			return .primary
		}
	}
	
	var badgeData : BadgeData {
		switch self {
		case .failedToGetUserLocation:
			return BadgeData(name: "Failed to get user Location")
		case .offlineMode:
			return BadgeData(name: "Offline Mode")
		case .timeDepartureTimeArrival:
			return BadgeData(style: Color.chewFillSecondary)
		case .date:
			return BadgeData(style: Color.chewFillSecondary)
		case .updatedAtTime:
			return BadgeData(style: Color.chewFillSecondary)
		case .price(let price):
			return BadgeData(name: price)
		case .dticket:
			return BadgeData(
				style: Color.chewGray10,
				name: "DeutschlandTicket")
		case .cancelled:
			return BadgeData(
				style: Color.chewFillRedPrimary,
				name: "cancelled")
		case .connectionNotReachable:
			return BadgeData(
				style: Color.chewFillRedPrimary,
				name: "not reachable")
		case .alertFromRemark:
			return BadgeData(
				style: Color.chewFillRedPrimary,
				name: "!")
		case .lineNumber(_, num: let num):
			return BadgeData(style: .chewGrayScale10, name: num.replacingOccurrences(of: " ", with: ""))
		case .legDuration(let dur):
			return BadgeData(name: dur)
		case .legDirection(let dir):
			return BadgeData(name: dir)
		case .walking(let duration):
			return BadgeData(
				name: String(duration))
		case .transfer(duration: let dur):
			return BadgeData(
				name: String(dur))
		case .stopsCount(let num, _):
			let tail = num == 1 ? " stop" : " stops"
			return BadgeData(
				name: String(num) + tail)
		case .departureArrivalStops:
			return BadgeData(name: "")
		case .changesCount:
			return BadgeData(name: "")
		}
	}
}
