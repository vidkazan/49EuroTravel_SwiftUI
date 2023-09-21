//
//  constructJourneys+Leg.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//

import Foundation
import UIKit

extension JourneyListViewModel {

	func constructLegName(leg : Leg) -> String {
		return "line"
	}
	
	func constructLineData(leg : Leg) -> LegViewData.LineViewData? {
		guard let line = leg.line else { return nil }
		return .init(name: line.name ?? " line" )
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
			direction: leg.direction ?? "direction",
			duration: DateParcer.getTimeStringWithHoursAndMinutesFormat(
				minutes: DateParcer.getTwoDateIntervalInMinutes(
					date1: actualDepartureTS,
					date2: actualArrivalTS
				)) ?? "duration",
			name: constructLegName(leg: leg),
			legTopPosition: max(plannedDeparturePosition,actualDeparturePosition),
			legBottomPosition: max(plannedArrivalPosition,actualArrivalPosition),
			delayedAndNextIsNotReachable: nil,
			remarks: leg.remarks,
			lineViewData: constructLineData(leg: leg),
			legStopsViewData: constructLineStopOverData(leg: leg)
		)
		return res
	}
	
	func currentLegIsNotReachable(currentLeg: LegViewData?, previousLeg: LegViewData?) -> Bool {
		guard let currentLeg = currentLeg, let previousLeg = previousLeg else { return false }
		return previousLeg.legBottomPosition > currentLeg.legTopPosition
	}
}
