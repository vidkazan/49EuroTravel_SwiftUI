//
//  constructJourneys+Leg.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//

import Foundation
import UIKit
import SwiftUI

extension JourneyListViewModel {
	func constructLegType(leg : Leg) -> LegViewData.LegType {
		if let dist = leg.distance {
			return .foot(distance: dist)
		}
		if let line = leg.line, let mode = line.mode {
			switch mode {
			case "train":
				return .train(name: line.name ?? "train")
			case "bus":
				return .bus(name: line.name ?? "bus")
			default:
				return .custom(name: mode)
			}
		}
		return .custom(name: "wtf??")
	}
	func constructLegFillColor(leg : Leg) -> Color {
		switch leg.reachable ?? true {
		case true:
//			switch constructLegType(leg: leg) {
//			case .foot:
//				return Color.init(uiColor: .systemGray3)
//			case .bus,.train,.custom:
				return Color.init(uiColor: .systemGray5)
//			}
		case false:
			return Color(hue: 0, saturation: 1, brightness: 0.4)
		}
	}
	func constructLineStopOverData(leg : Leg) -> [LegViewData.StopViewData] {
		guard let stops = leg.stopovers else { return [] }
		let res = stops.map { stop -> LegViewData.StopViewData in
				.init(
					name: stop.stop?.name ?? "stop",
					departurePlannedTimeString: DateParcer.getTimeStringFromDate(date: DateParcer.getDateFromDateString(dateString: stop.plannedDeparture)) ?? "time",
					departureActualTimeString: DateParcer.getTimeStringFromDate(date: DateParcer.getDateFromDateString(dateString: stop.departure)) ?? "time",
					arrivalPlannedTimeString: DateParcer.getTimeStringFromDate(date: DateParcer.getDateFromDateString(dateString: stop.plannedArrival)) ?? "time",
					arrivalActualTimeString: DateParcer.getTimeStringFromDate(date: DateParcer.getDateFromDateString(dateString: stop.arrival)) ?? "time",
					departurePlatform: stop.departurePlatform,
					plannedDeparturePlatform: stop.plannedDeparturePlatform
				)
		}
		return res
	}
	
	func constructLegData(leg : Leg,firstTS: Date?, lastTS: Date?,id : Int) -> LegViewData? {
		guard
			let plannedDepartureTSString = leg.plannedDeparture,
			let plannedArrivalTSString = leg.plannedArrival,
			let actualDepartureTSString = leg.departure,
			let actualArrivalTSString = leg.arrival else { return nil }
		
		let plannedDepartureTS = DateParcer.getDateFromDateString(dateString: plannedDepartureTSString)
		let plannedArrivalTS = DateParcer.getDateFromDateString(dateString: plannedArrivalTSString)
		let actualDepartureTS = DateParcer.getDateFromDateString(dateString: actualDepartureTSString)
		let actualArrivalTS = DateParcer.getDateFromDateString(dateString: actualArrivalTSString)
		
		guard let plannedDeparturePosition = getTimeLabelPosition(firstTS: firstTS, lastTS: lastTS,currentTS: plannedDepartureTS),
			  let actualDeparturePosition = getTimeLabelPosition( firstTS: firstTS, lastTS: lastTS,	currentTS: actualDepartureTS),
			  let plannedArrivalPosition = getTimeLabelPosition( firstTS: firstTS, lastTS: lastTS,	currentTS: plannedArrivalTS),
			  let actualArrivalPosition = getTimeLabelPosition( firstTS: firstTS, lastTS: lastTS,	currentTS: actualArrivalTS) else { return nil }
		
		let res = LegViewData(
			id: id,
			fillColor: constructLegFillColor(leg: leg),
			legType: constructLegType(leg: leg),
			direction: leg.direction ?? "direction",
			duration: DateParcer.getTimeStringWithHoursAndMinutesFormat(
				minutes: DateParcer.getTwoDateIntervalInMinutes(
					date1: actualDepartureTS,
					date2: actualArrivalTS
				)) ?? "duration",
			legTopPosition: max(plannedDeparturePosition,actualDeparturePosition),
			legBottomPosition: max(plannedArrivalPosition,actualArrivalPosition),
			delayedAndNextIsNotReachable: nil,
			remarks: leg.remarks,
			legStopsViewData: constructLineStopOverData(leg: leg)
		)
		return res
	}
	
	func currentLegIsNotReachable(currentLeg: LegViewData?, previousLeg: LegViewData?) -> Bool {
		guard let currentLeg = currentLeg, let previousLeg = previousLeg else { return false }
		return previousLeg.legBottomPosition > currentLeg.legTopPosition
	}
}
