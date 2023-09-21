//
//  Badges.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 21.09.23.
//

import Foundation
import SwiftUI

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
	case walkingDistance(Int)
	
	case lineNumber(num : String)
	case legDuration(dur : String)
	case legDirection(dir : String)
	case walking(direction : String)
	 
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
		case .walkingDistance:
			return 8
		case .walking:
			return 9
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
				name: "!")
		case .lineNumber(num: let num):
			return BadgeData(name: num)
		case .legDuration(let dur):
			return BadgeData(name: dur)
		case .legDirection(let dir):
			return BadgeData(name: dir)
		case .walkingDistance(let dist):
			return BadgeData(
				style: Color(hue: 0.12, saturation: 0.9, brightness: 0.7),
				name: String(dist) + "m")
		case .walking(direction: let direction):
			return BadgeData(
				name: String(direction)
			)
		}
	}
}
