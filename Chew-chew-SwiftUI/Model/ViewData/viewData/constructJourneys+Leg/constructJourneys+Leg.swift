//
//  constructJourneyList+Leg.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//

import Foundation
import UIKit
import SwiftUI
import CoreLocation

extension LegDTO {
	
	func legViewData(firstTS: Date?, lastTS: Date?, legs : [LegDTO]?) -> LegViewData? {
		do {
			return try legViewDataThrows(firstTS: firstTS, lastTS: lastTS, legs: legs)
		} catch  {
			return nil
		}
	}
	
	func legViewDataThrows(firstTS: Date?, lastTS: Date?, legs : [LegDTO]?) throws -> LegViewData {
		let container = TimeContainer(
			plannedDeparture: plannedDeparture,
			plannedArrival: plannedArrival,
			actualDeparture: departure,
			actualArrival: arrival,
			cancelled: nil
		)
		guard
			let plannedDeparturePosition = getTimeLabelPosition(
				firstTS: firstTS,
				lastTS: lastTS,
				currentTS: container.date.departure.planned
			),
			let plannedArrivalPosition = getTimeLabelPosition(
				firstTS: firstTS,
				lastTS: lastTS,
				currentTS: container.date.arrival.planned
			) else {
			throw ConstructDataError.nilValue(type: "plannedArrivalPosition or plannedDeparturePosition")
		}
		
		
		guard let tripId = walking == true ? UUID().uuidString : tripId else  {
			throw ConstructDataError.nilValue(type: "tripId")
		}
		
		
		let actualDeparturePosition = getTimeLabelPosition(
			firstTS: firstTS,
			lastTS: lastTS,
			currentTS: container.date.departure.actual
		) ?? 0
		
		let actualArrivalPosition = getTimeLabelPosition(
			firstTS: firstTS,
			lastTS: lastTS,
			currentTS: container.date.arrival.actual
		) ?? 0
		
		let stops = stopViewData(type: constructLegType(leg: self, legs: legs))
		let segments = constructSegmentsFromStopOverData(stopovers: stops)
		
		let res = LegViewData(
			isReachable: stops.first?.cancellationType() != .fullyCancelled && stops.last?.cancellationType() != .fullyCancelled,
			legType: constructLegType(leg: self, legs: legs),
			tripId: tripId,
			direction: direction ?? "direction",
			duration: DateParcer.getTimeStringWithHoursAndMinutesFormat(
				minutes: DateParcer.getTwoDateIntervalInMinutes(
					date1: container.date.departure.actual,
					date2: container.date.arrival.actual
				)) ?? DateParcer.getTimeStringWithHoursAndMinutesFormat(
					minutes: DateParcer.getTwoDateIntervalInMinutes(
						date1: container.date.departure.planned,
						date2: container.date.arrival.planned
					)) ?? "",
			legTopPosition: max(plannedDeparturePosition,actualDeparturePosition),
			legBottomPosition: max(plannedArrivalPosition,actualArrivalPosition),
			delayedAndNextIsNotReachable: nil,
			remarks: remarks,
			legStopsViewData: stops,
			footDistance: distance ?? 0,
			lineViewData: constructLineViewData(
				mode: line?.mode ?? "mode",
				product: line?.product ?? "product",
				name: line?.name ?? "lineName",
				productName: line?.productName ?? "productName"
			),
			progressSegments: segments,
			time: container,
			polyline: polyline
		)
		return res
	}
}
func currentLegIsNotReachable(currentLeg: LegViewData?, previousLeg: LegViewData?) -> Bool? {
	guard let currentLeg = currentLeg?.time.timestamp.departure.actual,
			let previousLeg = previousLeg?.time.timestamp.arrival.actual else { return nil }
	return previousLeg > currentLeg
}
