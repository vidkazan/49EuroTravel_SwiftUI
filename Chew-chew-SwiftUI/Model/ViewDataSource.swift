//
//  ViewDataSourse.swift
//  49EuroTravel
//
//  Created by Dmitrii Grigorev on 09.08.23.
//

import Foundation
import UIKit

struct BadgeDataSource : Equatable {
	let color : UIColor
	let name : String
	
	init(color : UIColor, name : String){
		self.name = name
		self.color = color
	}
}

enum BadgesList {
	case price(price: String)
	case dticket
	case cancelled
	case connectionNotReachable
	
	var badgeView : BadgeView {
		switch self {
		case .price(let price):
			return BadgeView(badge: BadgeDataSource(
				color: .red,
				name: price))
		case .dticket:
			return BadgeView(badge: BadgeDataSource(
				color: .green,
				name: "DeutschlandTicket"))
		case .cancelled:
			return BadgeView(badge: BadgeDataSource(
				color: .red,
				name: "cancelled"))
		case .connectionNotReachable:
			return BadgeView(badge: BadgeDataSource(
				color: .red,
				name: "connection is not reachable"))
		}
	}
}

struct TimelineTimeLabelDataSourse : Equatable {
	let text : String
	let textCenterYposition : Double
}

struct TimelineViewDataSourse : Equatable {
	let timeLabels : [TimelineTimeLabelDataSourse]
}

struct LegViewDataSourse : Equatable,Identifiable {
	let id : Int
	let name : String
	let legTopPosition : Double
	let legBottomPosition : Double
	var color : UIColor
}

struct JourneyCollectionViewDataSourse : Equatable, Identifiable {
	let id : Int
	let startTimeLabelText : String
	let endTimeLabelText : String
	let durationLabelText : String
	let legs : [LegViewDataSourse]
}

struct JourneyViewDataSourse : Equatable {
	let legs : [LegViewDataSourse]
}

struct AllJourneysCollectionViewDataSourse : Equatable {
	let awaitingData : Bool
	let journeys : [JourneyCollectionViewDataSourse]
}

struct ResultJourneyViewDataSourse : Equatable {
	let awaitingData : Bool
	let journeys : [JourneyViewDataSourse]?
	let timeline : TimelineViewDataSourse?
}
