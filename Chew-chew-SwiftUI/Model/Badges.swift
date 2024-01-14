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

enum Badges : Hashable {
	case timeDepartureTimeArrival(timeDeparture: String,timeArrival: String)
	case date(dateString : String)
	case price(_ price: String)
	case dticket
	case cancelled
	case connectionNotReachable
	case alertFromRemark
	
	case lineNumber(lineType:LineType,num : String)
	case stopsCount(Int)
	case legDuration(dur : String)
	case legDirection(dir : String)
	case walking(duration : String)
	case transfer(duration : String)
	
	case updatedAtTime(referenceTime : Double)
	
	
	var badgeData : BadgeData {
		switch self {
		case .timeDepartureTimeArrival:
			return BadgeData(style: Color.chewFillSecondary)
		case .date:
			return BadgeData(style: Color.chewFillSecondary)
		case .updatedAtTime:
			return BadgeData(style: Color.chewFillSecondary)
		case .price(let price):
			return BadgeData(
				style: Color(hue: 0.5, saturation: 1, brightness: 0.4),
				name: price)
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
		case .stopsCount(let num):
			let tail = num == 1 ? " stop" : " stops"
			return BadgeData(
				name: String(num) + tail)
		}
	}
}
