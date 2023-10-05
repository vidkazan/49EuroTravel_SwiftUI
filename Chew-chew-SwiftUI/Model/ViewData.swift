//
//  ViewData.swift
//  49EuroTravel
//
//  Created by Dmitrii Grigorev on 09.08.23.
//

import Foundation
import SwiftUI

struct JourneyViewData : Equatable {
	let id = UUID()
	let origin : String
	let destination : String
	
	let startDateString : String
	let endDateString : String
	let durationLabelText : String
	
	let legs : [LegViewData]
	let transferCount : Int
	let sunEvents : [SunEvent]
	let isReachable : Bool
	let badges : [Badges]
	let refreshToken : String?
	let timeContainer : TimeContainer
}

struct LegViewData : Equatable,Identifiable{
	let id = UUID()
	let isReachable : Bool
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
	let progressSegments : Segments
	let timeContainer : TimeContainer
}

struct StopViewData : Equatable,Identifiable {
	let id = UUID()
	let name : String
	let departurePlatform,
		plannedDeparturePlatform	: String?
	let arrivalPlatform,
		plannedArrivalPlatform	: String?
	let timeContainer : TimeContainer
	let type : StopOverType
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


extension StopViewData {
	init(name : String,timeContainer : TimeContainer,type: StopOverType) {
		self.timeContainer = timeContainer
		self.name = name
		self.departurePlatform = ""
		self.plannedDeparturePlatform = ""
		self.arrivalPlatform = ""
		self.plannedArrivalPlatform = ""
		self.type = type
	}
	init(name : String,timeContainer : TimeContainer, stop : StopOver,type: StopOverType) {
		self.timeContainer = timeContainer
		self.name = name
		self.departurePlatform = stop.departurePlatform
		self.plannedDeparturePlatform = stop.plannedDeparturePlatform
		self.arrivalPlatform = stop.arrivalPlatform
		self.plannedArrivalPlatform = stop.plannedArrivalPlatform
		self.type = type
	}
	init(name : String,timeContainer : TimeContainer, leg : Leg,type: StopOverType) {
		self.timeContainer = timeContainer
		self.name = name
		self.departurePlatform = leg.departurePlatform
		self.plannedDeparturePlatform = leg.plannedDeparturePlatform
		self.arrivalPlatform = leg.arrivalPlatform
		self.plannedArrivalPlatform = leg.plannedArrivalPlatform
		self.type = type
		
	}
}

extension LegViewData {
	enum LegType : Equatable,Hashable {
		case footStart(startPointName : String)
		case footMiddle
		case footEnd(finishPointName : String)
		case transfer
		case line
	}
}
