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
		self.name = ""
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

enum Badges : Equatable {
	case fullLegError
	case followError(_ action : JourneyFollowViewModel.Action)
	case locationError
	case offlineMode
	case departureArrivalStops(departure: String,arrival: String)
	case changesCount(_ count : Int)
	case timeDepartureTimeArrival(timeContainer : TimeContainer)
	case date(date : Date)
	case price(_ price: String)
	case dticket
	case cancelled
	case connectionNotReachable
	case remarkImportant(remarks : [RemarkViewData])
	
	case lineNumber(lineType:LineType,num : String)
	case stopsCount(_ count : Int,_ mode : StopsCountBadgeMode)
	case legDirection(dir : String, strikethrough : Bool)
	
	case legDuration(_ timeContainer : TimeContainer)
	case walking(_ timeContainer : TimeContainer)
	case transfer(_ timeContainer : TimeContainer)
	
	case distanceInMeters(dist : Double)
	
	case updatedAtTime(referenceTime : Double, isLoading : Bool = false)
	
	var badgeAction : ()->Void {
		switch self{
		case .remarkImportant(remarks: let remark):
			return {
				Model.shared.sheetViewModel.send(event: .didRequestShow(.remark(remarks: remark)))
			}
		default:
			return {}
		}
	}
	
	var badgeDefaultStyle : BadgeBackgroundBaseStyle {
		switch self {
		case .cancelled,
			 .connectionNotReachable,
			 .remarkImportant:
			return .red
		default:
			return .primary
		}
	}
	
	var badgeData : BadgeData {
		switch self {
		case .fullLegError:
			return BadgeData(name: "Failed to load full leg")
		case .followError(let action):
			return BadgeData(name: "Failed to \(action.description) this journey")
		case .locationError:
			return BadgeData(name: "Failed to get Location")
		case .offlineMode:
			return BadgeData(name: "Offline Mode")
		case .price:
			return BadgeData()
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
		case .remarkImportant:
			return BadgeData(
				style: Color.chewFillRedPrimary,
				name: "!")
		case .lineNumber(_, num: let num):
			return BadgeData(style: .chewGrayScale10, name: num.replacingOccurrences(of: " ", with: ""))
		case let .legDirection(dir,_):
			return BadgeData(name: dir)
		case .stopsCount(let num, _):
			let tail = num == 1 ? " stop" : " stops"
			return BadgeData(
				name: String(num) + tail)
			
			
		case .distanceInMeters:
			return BadgeData()
		case .walking:
			return BadgeData(name: "walk ")
		case .legDuration:
			return BadgeData()
		case .transfer:
			return BadgeData(name: "transfer ")
		case .departureArrivalStops:
			return BadgeData()
		case .changesCount:
			return BadgeData()
		case .timeDepartureTimeArrival:
			return BadgeData(style: Color.chewFillSecondary)
		case .date:
			return BadgeData(style: Color.chewFillSecondary)
		case .updatedAtTime:
			return BadgeData(style: Color.chewFillSecondary)
		}
	}
}
