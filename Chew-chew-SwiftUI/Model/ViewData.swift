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
	let realtimeDataUpdatedAt: Double?
	init(
		journeysViewData : [JourneyViewData],
		data: JourneyListDTO,
		depStop: Stop,
		arrStop : Stop
	) {
		self.journeys = journeysViewData
		self.laterRef = data.laterRef
		self.earlierRef = data.earlierRef
		self.realtimeDataUpdatedAt = Double(data.realtimeDataUpdatedAt ?? 0)
	}
}

struct JourneyViewData : Equatable, Identifiable {
	let id = UUID()
	let origin : String
	let destination : String
	let durationLabelText : String
	let legs : [LegViewData]
	let transferCount : Int
	let sunEvents : [SunEvent]
	let sunEventsGradientStops : [Gradient.Stop]
	let isReachable : Bool
	let badges : [Badges]
	let refreshToken : String
	let timeContainer : TimeContainer
	let updatedAt : Double
}

extension JourneyViewData {
	init(from data: JourneyViewData) {
		self.origin = data.origin
		self.destination = data.destination
		self.durationLabelText = data.durationLabelText
		self.legs = data.legs
		self.transferCount = data.transferCount
		self.sunEvents = data.sunEvents
		self.isReachable = data.isReachable
		self.badges = data.badges
		self.refreshToken = data.refreshToken
		self.timeContainer = data.timeContainer
		self.updatedAt = data.updatedAt
		self.sunEventsGradientStops = data.sunEventsGradientStops
	}
	init(
		journeyRef : String,
		badges : [Badges],
		sunEvents : [SunEvent],
		legs : [LegViewData],
		depStopName : String?,
		arrStopName : String?,
		time : TimeContainer,
		updatedAt : Double
	){
		self.origin = depStopName ?? "origin"
		self.destination = arrStopName ?? "destination"
		self.durationLabelText  = DateParcer.getTimeStringWithHoursAndMinutesFormat(minutes: time.durationInMinutes) ?? "duration"
		self.legs = legs
		self.transferCount = constructTransferCount(legs: legs)
		self.sunEvents = sunEvents
		self.isReachable = true
		self.badges = badges
		self.refreshToken = Self.fixRefreshToken(token: journeyRef)
		self.timeContainer = time
		self.updatedAt = updatedAt
		self.sunEventsGradientStops = getGradientStops(
			startDateTS: timeContainer.timestamp.departure.actual,
			endDateTS: timeContainer.timestamp.arrival.actual,
			sunEvents: sunEvents
		)
	}
	
	static func fixRefreshToken(token : String) -> String {
		let pattern = "\\$\\$\\d+\\$\\$\\$\\$\\$\\$"
		let res = token.replacingOccurrences(of: pattern, with: "",options: .regularExpression).replacingOccurrences(of: "/", with: "%2F")
		return res
	}
}

struct LegViewData : Equatable,Identifiable {
	let id = UUID()
	let isReachable : Bool
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
	let timeContainer : TimeContainer
	let polyline : PolylineDTO?
}

extension LegViewData {
	init(){
		self.isReachable = false
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
		self.timeContainer = .init(plannedDeparture: "", plannedArrival: "", actualDeparture: "", actualArrival: "", cancelled: false)
		self.remarks = []
		self.polyline = nil
	}
}

struct StopViewData : Equatable,Identifiable {
	let id = UUID()
	let locationCoordinates : CLLocationCoordinate2D
	let name : String
	let departurePlatform : Prognosed<String?>
	let arrivalPlatform : Prognosed<String?>
	let timeContainer : TimeContainer
	let stopOverType : StopOverType
	let isCancelled : Bool?
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
		stop : StopWithTimeDTO,
		type: StopOverType,
		isCancelled : Bool?
	) {
		self.timeContainer = timeContainer
		self.name = name
		self.departurePlatform  = Prognosed(actual: stop.departurePlatform, planned: stop.plannedDeparturePlatform)
		self.arrivalPlatform  = Prognosed(actual: stop.arrivalPlatform, planned: stop.plannedArrivalPlatform)
		self.stopOverType = type
		self.locationCoordinates = CLLocationCoordinate2D(
			latitude: stop.stop?.location?.latitude ?? stop.stop?.latitude ?? -1,
			longitude: stop.stop?.location?.longitude ?? stop.stop?.longitude ?? -1
		)
		self.isCancelled = isCancelled
	}
	
	init(
		name : String,
		timeContainer : TimeContainer,
		type: StopOverType,
		coordinates : CLLocationCoordinate2D,
		isCancelled : Bool?
	) {
		self.timeContainer = timeContainer
		self.name = name
		self.departurePlatform  = Prognosed(actual: nil, planned: nil)
		self.arrivalPlatform  = Prognosed(actual: nil, planned: nil)
		self.stopOverType = type
		self.locationCoordinates = coordinates
		self.isCancelled = isCancelled
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
