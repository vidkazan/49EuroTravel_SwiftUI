//
//  constructJourneys+Leg.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//

import Foundation
import UIKit
import SwiftUI

extension JourneyViewDataConstructor {
	func constructLineStopOverData(leg : Leg, type : LegType) -> [LegViewData.StopViewData] {
		var name : String? {
			switch type {
			case .foot(let place):
				switch place {
				case .atStart(let startPointName):
					return startPointName
				case .inBetween:
					return nil
				case .atFinish(let finishPointName):
					return finishPointName
				}
			case .transfer:
				return nil
			case .line:
				return nil
			}
		}
		
		switch type {
		case .foot(place: let place):
			switch place {
			case .atStart:
				return [
					.init(
						name: name ?? leg.origin?.name ?? "origin name",
						departurePlannedTimeString: DateParcer.getTimeStringFromDate(date: DateParcer.getDateFromDateString(dateString: leg.plannedDeparture)) ?? "time",
						departureActualTimeString: DateParcer.getTimeStringFromDate(date: DateParcer.getDateFromDateString(dateString: leg.plannedDeparture)) ?? "time",
						arrivalPlannedTimeString: DateParcer.getTimeStringFromDate(date: DateParcer.getDateFromDateString(dateString: leg.plannedArrival)) ?? "time",
						arrivalActualTimeString: DateParcer.getTimeStringFromDate(date: DateParcer.getDateFromDateString(dateString: leg.plannedArrival)) ?? "time",
						departurePlatform: leg.departurePlatform,
						plannedDeparturePlatform: leg.plannedDeparturePlatform,
						arrivalPlatform: leg.arrivalPlatform,
						plannedArrivalPlatform: leg.plannedArrivalPlatform,
						departureDelay: leg.departureDelay ?? 0,
						arrivalDelay: leg.arrivalDelay ?? 0
					),
					.init(
						name: name ?? leg.destination?.name ?? "dest name",
						departurePlannedTimeString: DateParcer.getTimeStringFromDate(date: DateParcer.getDateFromDateString(dateString: leg.plannedDeparture)) ?? "time",
						departureActualTimeString: DateParcer.getTimeStringFromDate(date: DateParcer.getDateFromDateString(dateString: leg.departure)) ?? "time",
						arrivalPlannedTimeString: DateParcer.getTimeStringFromDate(date: DateParcer.getDateFromDateString(dateString: leg.plannedArrival)) ?? "time",
						arrivalActualTimeString: DateParcer.getTimeStringFromDate(date: DateParcer.getDateFromDateString(dateString: leg.arrival)) ?? "time",
						departurePlatform: leg.departurePlatform,
						plannedDeparturePlatform: leg.plannedDeparturePlatform,
						arrivalPlatform: leg.arrivalPlatform,
						plannedArrivalPlatform: leg.plannedArrivalPlatform,
						departureDelay: leg.departureDelay ?? 0,
						arrivalDelay: leg.arrivalDelay ?? 0
					)
				]
			case .inBetween, .atFinish:
				return [
					.init(
						name: name ?? leg.origin?.name ?? "origin name",
						departurePlannedTimeString: DateParcer.getTimeStringFromDate(date: DateParcer.getDateFromDateString(dateString: leg.plannedDeparture)) ?? "time",
						departureActualTimeString: DateParcer.getTimeStringFromDate(date: DateParcer.getDateFromDateString(dateString: leg.departure)) ?? "time",
						arrivalPlannedTimeString: DateParcer.getTimeStringFromDate(date: DateParcer.getDateFromDateString(dateString: leg.plannedArrival)) ?? "time",
						arrivalActualTimeString: DateParcer.getTimeStringFromDate(date: DateParcer.getDateFromDateString(dateString: leg.arrival)) ?? "time",
						departurePlatform: leg.departurePlatform,
						plannedDeparturePlatform: leg.plannedDeparturePlatform,
						arrivalPlatform: leg.arrivalPlatform,
						plannedArrivalPlatform: leg.plannedArrivalPlatform,
						departureDelay: leg.departureDelay ?? 0,
						arrivalDelay: leg.arrivalDelay ?? 0
					),
					.init(
						name: name ?? leg.destination?.name ?? "dest name",
						departurePlannedTimeString: DateParcer.getTimeStringFromDate(date: DateParcer.getDateFromDateString(dateString: leg.plannedDeparture)) ?? "time",
						departureActualTimeString: DateParcer.getTimeStringFromDate(date: DateParcer.getDateFromDateString(dateString: leg.departure)) ?? "time",
						arrivalPlannedTimeString: DateParcer.getTimeStringFromDate(date: DateParcer.getDateFromDateString(dateString: leg.plannedArrival)) ?? "time",
						arrivalActualTimeString: DateParcer.getTimeStringFromDate(date: DateParcer.getDateFromDateString(dateString: leg.arrival)) ?? "time",
						departurePlatform: leg.departurePlatform,
						plannedDeparturePlatform: leg.plannedDeparturePlatform,
						arrivalPlatform: leg.arrivalPlatform,
						plannedArrivalPlatform: leg.plannedArrivalPlatform,
						departureDelay: leg.departureDelay ?? 0,
						arrivalDelay: leg.arrivalDelay ?? 0
					)
				]
			}
		case .transfer:
			return [
				.init(
					name: name ?? leg.origin?.name ?? "origin name",
					departurePlannedTimeString: DateParcer.getTimeStringFromDate(date: DateParcer.getDateFromDateString(dateString: leg.plannedDeparture)) ?? "time",
					departureActualTimeString: DateParcer.getTimeStringFromDate(date: DateParcer.getDateFromDateString(dateString: leg.departure)) ?? "time",
					arrivalPlannedTimeString: DateParcer.getTimeStringFromDate(date: DateParcer.getDateFromDateString(dateString: leg.plannedArrival)) ?? "time",
					arrivalActualTimeString: DateParcer.getTimeStringFromDate(date: DateParcer.getDateFromDateString(dateString: leg.arrival)) ?? "time",
					departurePlatform: leg.departurePlatform,
					plannedDeparturePlatform: leg.plannedDeparturePlatform,
					arrivalPlatform: leg.arrivalPlatform,
					plannedArrivalPlatform: leg.plannedArrivalPlatform,
					departureDelay: leg.departureDelay ?? 0,
					arrivalDelay: leg.arrivalDelay ?? 0
				),
				.init(
					name: name ?? leg.destination?.name ?? "dest name",
					departurePlannedTimeString: DateParcer.getTimeStringFromDate(date: DateParcer.getDateFromDateString(dateString: leg.plannedDeparture)) ?? "time",
					departureActualTimeString: DateParcer.getTimeStringFromDate(date: DateParcer.getDateFromDateString(dateString: leg.departure)) ?? "time",
					arrivalPlannedTimeString: DateParcer.getTimeStringFromDate(date: DateParcer.getDateFromDateString(dateString: leg.plannedArrival)) ?? "time",
					arrivalActualTimeString: DateParcer.getTimeStringFromDate(date: DateParcer.getDateFromDateString(dateString: leg.arrival)) ?? "time",
					departurePlatform: leg.departurePlatform,
					plannedDeparturePlatform: leg.plannedDeparturePlatform,
					arrivalPlatform: leg.arrivalPlatform,
					plannedArrivalPlatform: leg.plannedArrivalPlatform,
					departureDelay: leg.departureDelay ?? 0,
					arrivalDelay: leg.arrivalDelay ?? 0
				)
			]
		case .line:
			guard let stops = leg.stopovers else { return [] }
			let res = stops.map { stop -> LegViewData.StopViewData in
					.init(
						name: stop.stop?.name ?? "stop",
						departurePlannedTimeString: DateParcer.getTimeStringFromDate(date: DateParcer.getDateFromDateString(dateString: stop.plannedDeparture)) ?? "time",
						departureActualTimeString: DateParcer.getTimeStringFromDate(date: DateParcer.getDateFromDateString(dateString: stop.departure)) ?? "time",
						arrivalPlannedTimeString: DateParcer.getTimeStringFromDate(date: DateParcer.getDateFromDateString(dateString: stop.plannedArrival)) ?? "time",
						arrivalActualTimeString: DateParcer.getTimeStringFromDate(date: DateParcer.getDateFromDateString(dateString: stop.arrival)) ?? "time",
						departurePlatform: stop.departurePlatform,
						plannedDeparturePlatform: stop.plannedDeparturePlatform,
						arrivalPlatform: stop.arrivalPlatform,
						plannedArrivalPlatform: stop.plannedArrivalPlatform,
						departureDelay: stop.departureDelay ?? 0,
						arrivalDelay: stop.arrivalDelay ?? 0
					)
			}
			return res
		}
	}
}
