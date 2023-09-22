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
	func constructLegFillColor(leg : Leg) -> Color {
		switch leg.reachable ?? true {
		case true:
			return Color.init(uiColor: .systemGray5)
		case false:
			return Color(hue: 0, saturation: 1, brightness: 0.4)
		}
	}

	func constructLegData(leg : Leg,firstTS: Date?, lastTS: Date?,id : Int, legs : [Leg]) -> LegViewData? {
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
			legType: constructLegType(leg: leg, legs: legs),
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
			legStopsViewData: constructLineStopOverData(leg: leg, type : constructLegType(leg: leg, legs: legs)),
			footDistance: leg.distance ?? 0,
			lineName: leg.line?.name ?? leg.line?.mode ?? "line"
		)
		return res
	}
	
	func currentLegIsNotReachable(currentLeg: LegViewData?, previousLeg: LegViewData?) -> Bool {
		guard let currentLeg = currentLeg, let previousLeg = previousLeg else { return false }
		return previousLeg.legBottomPosition > currentLeg.legTopPosition
	}
}
