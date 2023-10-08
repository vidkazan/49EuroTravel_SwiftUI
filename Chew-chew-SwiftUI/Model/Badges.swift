//
//  Badges.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 21.09.23.
//

import Foundation
import SwiftUI

enum LineType :Equatable,Hashable {
	case nationalExpress
	case national
	case regionalExpress
	case regional
	case suburban
	case bus
	case ferry
	case subway
	case tram
	case taxi
	case transfer
	case foot
	case other(type: String)
	
	var color : Color {
		switch self {
		case .nationalExpress:
			return Color(red:0.94118, green:0.95294, blue:0.96078)
		case .national:
			return Color(red:0.84314, green:0.86275, blue:0.88235)
		case .regionalExpress:
			return Color(red:0.68627, green:0.70588, blue:0.73333)
		case .regional:
			return Color(red:0.39216, green:0.41176, blue:0.45098)
		case .suburban:
			return Color(red:0.25098, green:0.51373, blue:0.20784)
		case .bus:
			return Color(red: 129/255, green: 73/255, blue: 151/255)
		case .ferry:
			return Color(red: 48/255, green: 159/255, blue: 209/255)
		case .subway:
			return Color(red: 20/255, green: 85/255, blue: 192/255)
		case .tram:
			return Color(red: 197/255, green: 0/255, blue: 20/255)
		case .taxi:
			return Color(red: 255/255, green: 216/255, blue: 0/255)
		case .transfer:
			return .clear
		case .foot:
			return Color.chewGrayScale10
		case .other:
			return Color.chewGrayScale10
		}
	}
}

enum Badges : Identifiable,Hashable {
	struct BadgeData : Equatable, Identifiable {
		static func == (lhs: BadgeData, rhs: BadgeData) -> Bool {
			lhs.name == rhs.name
		}
		
		let id = UUID()
		let style : Color
		let name : String
		
		init(style : Color = Color.clear, name : String){
			self.name = name
			self.style = style
		}
	}
	case price(price: String)
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
		case .walking:
			return 8
		case .transfer:
			return 9
		case .stopsCount(_):
			return 10
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
				style: Color.chewGray10,
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
		case .lineNumber(let lineType, num: let num):
			return BadgeData(style: .chewGrayScale10, name: num)
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
			return BadgeData(
				name: String(num) + " stops")
		}
	}
}
