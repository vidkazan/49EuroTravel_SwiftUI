//
//  ViewData.swift
//  49EuroTravel
//
//  Created by Dmitrii Grigorev on 09.08.23.
//

import Foundation
import SwiftUI
import CoreLocation

struct JourneyListViewData : Equatable {
	let journeys : [JourneyViewData]
	let laterRef : String?
	let earlierRef : String?
	init(journeysViewData : [JourneyViewData],data: JourneyListContainer,depStop: Stop, arrStop : Stop) {
		self.journeys = journeysViewData
		self.laterRef = data.laterRef
		self.earlierRef = data.earlierRef
	}
}

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
	
	let tripId : String?
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
	let timeContainer : TimeContainer
	let polyline : Polyline?
}

struct StopViewData : Equatable,Identifiable {
	let id = UUID()
	let locationCoordinates : CLLocationCoordinate2D
	let name : String
	let departurePlatform : PrognosedTime<String?>
	let arrivalPlatform : PrognosedTime<String?>
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

struct LineViewData : Equatable {
	let type : LineType
	let name : String
	let shortName : String
}

extension StopViewData {
	init(
		name : String,
		timeContainer : TimeContainer,
		stop : StopOver,
		type: StopOverType
	) {
		self.timeContainer = timeContainer
		self.name = name
		self.departurePlatform  = PrognosedTime(actual: stop.departurePlatform, planned: stop.plannedDeparturePlatform)
		self.arrivalPlatform  = PrognosedTime(actual: stop.arrivalPlatform, planned: stop.plannedArrivalPlatform)
		self.type = type
		self.locationCoordinates = CLLocationCoordinate2D(
			latitude: stop.stop?.location?.latitude ?? stop.stop?.latitude ?? -1,
			longitude: stop.stop?.location?.longitude ?? stop.stop?.longitude ?? -1
		)
	}
	init(
		name : String,
		timeContainer : TimeContainer,
		type: StopOverType,
		coordinates : CLLocationCoordinate2D
	) {
		self.timeContainer = timeContainer
		self.name = name
		self.departurePlatform  = PrognosedTime(actual: nil, planned: nil)
		self.arrivalPlatform  = PrognosedTime(actual: nil, planned: nil)
		self.type = type
		self.locationCoordinates = coordinates
	}
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
