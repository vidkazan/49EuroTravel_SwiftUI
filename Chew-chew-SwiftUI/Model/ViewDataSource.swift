//
//  ViewDataSourse.swift
//  49EuroTravel
//
//  Created by Dmitrii Grigorev on 09.08.23.
//

import Foundation
import SwiftUI

struct BadgeDataSource : Equatable, Identifiable {
	let id = UUID()
	let color : UIColor
	let name : String
	
	init(color : UIColor, name : String){
		self.name = name
		self.color = color
	}
}

enum BadgesList : Identifiable {
	case price(price: String)
	case dticket
	case cancelled
	case connectionNotReachable
	 
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
		}
	}
	
	var badgeDataSourse : BadgeDataSource {
		switch self {
		case .price(let price):
			return BadgeDataSource(
				color: UIColor(hue: 0.5, saturation: 1, brightness: 0.4, alpha: 1),
				name: price)
		case .dticket:
			return BadgeDataSource(
				color: UIColor(hue: 0.35, saturation: 0, brightness: 0.4, alpha: 1),
				name: "DeutschlandTicket")
		case .cancelled:
			return BadgeDataSource(
				color: UIColor(hue: 0, saturation: 0.8, brightness: 0.6, alpha: 1),
				name: "cancelled")
		case .connectionNotReachable:
			return BadgeDataSource(
				color: UIColor(hue: 0, saturation: 0.8, brightness: 0.6, alpha: 1),
				name: "connection is not reachable")
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

struct AllJourneysCollectionViewDataSourse : Equatable{
	let awaitingData : Bool
	let journeys : [JourneyCollectionViewDataSourse]
}

struct ResultJourneyViewDataSourse : Equatable {
	let awaitingData : Bool
	let journeys : [JourneyViewDataSourse]?
	let timeline : TimelineViewDataSourse?
}
