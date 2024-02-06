//
//  ViewData.swift
//  49EuroTravel
//
//  Created by Dmitrii Grigorev on 09.08.23.
//

import Foundation
import SwiftUI
import CoreLocation

struct LegViewData : Equatable,Identifiable {
	let id = UUID()
	var isReachable : Bool
	let legType : LegType
	
	let tripId : String
//	PrognosedDirection<String>
	let direction : String
	let duration : String
	let legTopPosition : Double
	let legBottomPosition : Double
	var delayedAndNextIsNotReachable : Bool?
	let remarks : [Remark]?
	let legStopsViewData : [StopViewData]
	let footDistance : Int
	let lineViewData : LineViewData
	let progressSegments : Segments
	let time : TimeContainer
	let polyline : PolylineDTO?
}

extension LegViewData {
	init(){
		self.isReachable = true
		self.legType = .line
		self.tripId = ""
		self.duration = ""
		self.direction = ""
		self.legTopPosition = 0
		self.legBottomPosition = 0
		self.delayedAndNextIsNotReachable = false
		self.legStopsViewData = []
		self.footDistance = 0
		self.lineViewData = .init(type: .bus, name: "", shortName: "")
		self.progressSegments = .init(segments: [], heightTotalCollapsed: 0, heightTotalExtended: 0)
		self.time = .init(plannedDeparture: "", plannedArrival: "", actualDeparture: "", actualArrival: "", cancelled: false)
		self.remarks = []
		self.polyline = nil
	}
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

struct LineViewData : Equatable {
	let type : LineType
	let name : String
	let shortName : String
}

extension LegViewData {
	enum LegType : Equatable,Hashable {
		case footStart(startPointName : String)
		case footMiddle
		case footEnd(finishPointName : String)
		case transfer
		case line
		
		var caseDescription : String {
			switch self {
			case .footStart:
				return "footStart"
			case .footMiddle:
				return "footMiddle"
			case .footEnd:
				return "footEnd"
			case .transfer:
				return "transfer"
			case .line:
				return "line"
			}
		}
	}
}
