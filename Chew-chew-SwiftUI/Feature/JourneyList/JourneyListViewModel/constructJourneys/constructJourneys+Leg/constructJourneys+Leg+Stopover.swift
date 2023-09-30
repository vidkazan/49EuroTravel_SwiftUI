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
			case .transfer:
				return nil
			case .line:
				return nil
			case .footStart(startPointName: let name):
				return name
			case .footMiddle:
				return nil
			case .footEnd(finishPointName: let name):
				return name
			}
		}
		
		switch type {
		case .line:
			guard let stops = leg.stopovers else { return [] }
			let res = stops.map { stop -> LegViewData.StopViewData in
				let c = TimeContainer(plannedDeparture: leg.plannedDeparture, plannedArrival: leg.plannedArrival, actualDeparture: leg.departure, actualArrival: leg.arrival)
				return LegViewData.StopViewData(
						name: stop.stop?.name ?? "stop",
						departurePlannedTimeString: DateParcer.getTimeStringFromDate(date: c.date?.plannedDeparture) ?? "time",
						departureActualTimeString: DateParcer.getTimeStringFromDate(date: c.date?.actualDeparture) ?? "time",
						arrivalPlannedTimeString: DateParcer.getTimeStringFromDate(date: c.date?.plannedArrival) ?? "time",
						arrivalActualTimeString: DateParcer.getTimeStringFromDate(date: c.date?.actualArrival) ?? "time",
						departurePlatform: stop.departurePlatform,
						plannedDeparturePlatform: stop.plannedDeparturePlatform,
						arrivalPlatform: stop.arrivalPlatform,
						plannedArrivalPlatform: stop.plannedArrivalPlatform,
						departureDelay: stop.departureDelay ?? 0,
						arrivalDelay: leg.arrivalDelay ?? 0,
						timeContainer: c
					)
			}
			return res
		case .footStart:
			let first = TimeContainer(
				plannedDeparture: leg.plannedDeparture,
				plannedArrival: leg.plannedArrival,
				actualDeparture: leg.plannedDeparture,
				actualArrival: leg.plannedArrival
			)
			let last = TimeContainer(
				plannedDeparture: leg.plannedDeparture,
				plannedArrival: leg.plannedArrival,
				actualDeparture: leg.departure,
				actualArrival: leg.arrival
			)
			return [
				LegViewData.StopViewData(
					name: name ?? leg.origin?.name ?? "origin name",
					departurePlannedTimeString: DateParcer.getTimeStringFromDate(date: first.date?.plannedDeparture) ?? "time",
					departureActualTimeString: DateParcer.getTimeStringFromDate(date: first.date?.actualDeparture) ?? "time",
					arrivalPlannedTimeString: DateParcer.getTimeStringFromDate(date: first.date?.plannedArrival) ?? "time",
					arrivalActualTimeString: DateParcer.getTimeStringFromDate(date: first.date?.actualArrival) ?? "time",
					departurePlatform: leg.departurePlatform,
					plannedDeparturePlatform: leg.plannedDeparturePlatform,
					arrivalPlatform: leg.arrivalPlatform,
					plannedArrivalPlatform: leg.plannedArrivalPlatform,
					departureDelay: leg.departureDelay ?? 0,
					arrivalDelay: leg.arrivalDelay ?? 0,
					timeContainer: first
				),
				LegViewData.StopViewData(
					name: name ?? leg.destination?.name ?? "dest name",
					departurePlannedTimeString: DateParcer.getTimeStringFromDate(date: last.date?.plannedDeparture) ?? "time",
					departureActualTimeString: DateParcer.getTimeStringFromDate(date: last.date?.actualDeparture) ?? "time",
					arrivalPlannedTimeString: DateParcer.getTimeStringFromDate(date: last.date?.plannedArrival) ?? "time",
					arrivalActualTimeString: DateParcer.getTimeStringFromDate(date: last.date?.actualArrival) ?? "time",
					departurePlatform: leg.departurePlatform,
					plannedDeparturePlatform: leg.plannedDeparturePlatform,
					arrivalPlatform: leg.arrivalPlatform,
					plannedArrivalPlatform: leg.plannedArrivalPlatform,
					departureDelay: leg.departureDelay ?? 0,
					arrivalDelay: leg.arrivalDelay ?? 0,
					timeContainer: last
				)
			]
		case .footEnd, .footMiddle,.transfer:
			let c = TimeContainer(
				plannedDeparture: leg.plannedDeparture,
				plannedArrival: leg.plannedArrival,
				actualDeparture: leg.departure,
				actualArrival: leg.arrival
			)
			return [
				LegViewData.StopViewData(
					name: name ?? leg.origin?.name ?? "origin name",
					departurePlannedTimeString: DateParcer.getTimeStringFromDate(date: c.date?.plannedDeparture) ?? "time",
					departureActualTimeString: DateParcer.getTimeStringFromDate(date: c.date?.actualDeparture) ?? "time",
					arrivalPlannedTimeString: DateParcer.getTimeStringFromDate(date: c.date?.plannedArrival) ?? "time",
					arrivalActualTimeString: DateParcer.getTimeStringFromDate(date: c.date?.actualArrival) ?? "time",
					departurePlatform: leg.departurePlatform,
					plannedDeparturePlatform: leg.plannedDeparturePlatform,
					arrivalPlatform: leg.arrivalPlatform,
					plannedArrivalPlatform: leg.plannedArrivalPlatform,
					departureDelay: leg.departureDelay ?? 0,
					arrivalDelay: leg.arrivalDelay ?? 0,
					timeContainer: c
				),
				LegViewData.StopViewData(
					name: name ?? leg.destination?.name ?? "dest name",
					departurePlannedTimeString: DateParcer.getTimeStringFromDate(date: c.date?.plannedDeparture) ?? "time",
					departureActualTimeString: DateParcer.getTimeStringFromDate(date: c.date?.actualDeparture) ?? "time",
					arrivalPlannedTimeString: DateParcer.getTimeStringFromDate(date: c.date?.plannedArrival) ?? "time",
					arrivalActualTimeString: DateParcer.getTimeStringFromDate(date: c.date?.actualArrival) ?? "time",
					departurePlatform: leg.departurePlatform,
					plannedDeparturePlatform: leg.plannedDeparturePlatform,
					arrivalPlatform: leg.arrivalPlatform,
					plannedArrivalPlatform: leg.plannedArrivalPlatform,
					departureDelay: leg.departureDelay ?? 0,
					arrivalDelay: leg.arrivalDelay ?? 0,
					timeContainer: c
				)
			]
		}
	}
}
