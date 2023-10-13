//
//  ViewData.swift
//  49EuroTravel
//
//  Created by Dmitrii Grigorev on 09.08.23.
//

import Foundation
import SwiftUI
import CoreLocation

struct JourneysViewData : Equatable {
	let journeys : [JourneyViewData]
	let laterRef : String?
	let earlierRef : String?
	init(journeysViewData : [JourneyViewData],data: JourneysContainer,depStop: LocationType, arrStop : LocationType) {
		self.journeys = journeysViewData
		self.laterRef = data.laterRef
		self.earlierRef = data.earlierRef
	}
	init(data: JourneysContainer,depStop: LocationType, arrStop : LocationType) {
		self.journeys = constructJourneysViewData(journeysData: data, depStop: depStop, arrStop: arrStop)
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
}

struct StopViewData : Equatable,Identifiable {
	let id = UUID()
	let locationCoordinates : CLLocationCoordinate2D?
	let name : String
	let departurePlatform : PrognoseType<String?>
	let arrivalPlatform : PrognoseType<String?>
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
	init(name : String,timeContainer : TimeContainer, stop : StopOver,type: StopOverType) {
		self.timeContainer = timeContainer
		self.name = name
		self.departurePlatform  = PrognoseType(actual: stop.departurePlatform, planned: stop.plannedDeparturePlatform)
		self.arrivalPlatform  = PrognoseType(actual: stop.arrivalPlatform, planned: stop.plannedArrivalPlatform)
		self.type = type
		if let lat = stop.stop?.location?.latitude,let long = stop.stop?.location?.longitude {
			self.locationCoordinates = CLLocationCoordinate2D(latitude: lat, longitude: long)
		} else {
			self.locationCoordinates = nil
		}
	}
	init(name : String,timeContainer : TimeContainer,type: StopOverType, coordinates : LocationCoordinates?) {
		self.timeContainer = timeContainer
		self.name = name
		self.departurePlatform  = PrognoseType(actual: nil, planned: nil)
		self.arrivalPlatform  = PrognoseType(actual: nil, planned: nil)
		self.type = type
		if let lat = coordinates?.latitude, let lon = coordinates?.longitude {
			self.locationCoordinates = CLLocationCoordinate2D(latitude: lat, longitude: lon)
		} else {
			self.locationCoordinates = nil
		}
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
