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
	let legs : [LegViewData]
	let transferCount : Int
	let sunEvents : [SunEvent]
	let sunEventsGradientStops : [Gradient.Stop]
	let isReachable : Bool
	let remarks : [RemarkViewData]
	let badges : [Badges]
	let refreshToken : String
	let time : TimeContainer
	let updatedAt : Double
}

extension JourneyViewData {
	init(from data: JourneyViewData) {
		self.origin = data.origin
		self.destination = data.destination
		self.legs = data.legs
		self.transferCount = data.transferCount
		self.sunEvents = data.sunEvents
		self.isReachable = data.isReachable
		self.badges = data.badges
		self.refreshToken = data.refreshToken
		self.time = data.time
		self.updatedAt = data.updatedAt
		self.sunEventsGradientStops = data.sunEventsGradientStops
		self.remarks = data.remarks
	}
	init(
		journeyRef : String,
		badges : [Badges],
		sunEvents : [SunEvent],
		legs : [LegViewData],
		depStopName : String?,
		arrStopName : String?,
		time : TimeContainer,
		updatedAt : Double,
		remarks : [RemarkViewData]
	){
		self.origin = depStopName ?? "origin"
		self.destination = arrStopName ?? "destination"
		self.legs = legs
		self.transferCount = constructTransferCount(legs: legs)
		self.sunEvents = sunEvents
		self.isReachable = true
		self.badges = badges
		self.refreshToken = Self.fixRefreshToken(token: journeyRef)
		self.time = time
		self.updatedAt = updatedAt
		self.sunEventsGradientStops = getGradientStops(
			startDateTS: time.timestamp.departure.actualOrPlannedIfActualIsNil(),
			endDateTS: time.timestamp.arrival.actualOrPlannedIfActualIsNil(),
			sunEvents: sunEvents
		)
		self.remarks = remarks
	}
	
	static func fixRefreshToken(token : String) -> String {
		let pattern = "\\$\\$\\d+\\$\\$\\$\\$\\$\\$"
		let res = token.replacingOccurrences(of: pattern, with: "",options: .regularExpression).replacingOccurrences(of: "/", with: "%2F")
		return res
	}
}

extension JourneyViewData {
	struct Option {
		let action : (JourneyViewData)->()
		let icon : String
		let text : String
	}
	
	static let showOnMapOption = Option(
		action: { data in
			Model.shared.sheetViewModel.send(
				event: .didRequestShow(.mapDetails(.journey(data.legs)))
			)
		},
		icon: "map",
		text : NSLocalizedString(
			"Show on map", comment: "JourneyCell: menu item"
		)
	)
}
