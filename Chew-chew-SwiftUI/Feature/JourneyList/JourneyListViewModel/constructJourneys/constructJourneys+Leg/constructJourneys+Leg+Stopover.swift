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
			case .transfer,.line,.footMiddle:
				return nil
			case .footStart(startPointName: let name):
				return name
			case .footEnd(finishPointName: let name):
				return name
			}
		}
		
		switch type {
		case .line:
			guard let stops = leg.stopovers else { return [] }
			let res = stops.map { stop -> LegViewData.StopViewData in
				let c = TimeContainer(plannedDeparture: stop.plannedDeparture, plannedArrival: stop.plannedArrival, actualDeparture: stop.departure, actualArrival: stop.arrival)
				if stop == stops.first {
					return LegViewData.StopViewData(
						name: stop.stop?.name ?? "stop",
						timeContainer: c,
						stop: stop,
						type: .origin
					)
				} else if stop == stops.last {
					return LegViewData.StopViewData(
						name: stop.stop?.name ?? "stop",
						timeContainer: c,
						stop: stop,
						type: .destination
					)
				} else {
					return LegViewData.StopViewData(
						name: stop.stop?.name ?? "stop",
						timeContainer: c,
						stop: stop,
						type: .stopover
					)
				}
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
					timeContainer: first,
					leg: leg,
					type: .footTop
				)
//				LegViewData.StopViewData(
//					name: name ?? leg.destination?.name ?? "dest name",
//					timeContainer: last,
//					leg: leg,
//					type: .footBottom
//				)
			]
		case .footMiddle:
			let c = TimeContainer(
				plannedDeparture: leg.plannedDeparture,
				plannedArrival: leg.plannedArrival,
				actualDeparture: leg.departure,
				actualArrival: leg.arrival
			)
			return [
				LegViewData.StopViewData(
					name: name ?? leg.origin?.name ?? "origin name",
					timeContainer: c,
					leg: leg,
					type: .footMiddle
				)
//				LegViewData.StopViewData(
//					name: name ?? leg.destination?.name ?? "dest name",
//					timeContainer: c,
//					leg: leg,
//					type: .destination
//				)
			]
		case .footEnd:
			let c = TimeContainer(
				plannedDeparture: leg.plannedDeparture,
				plannedArrival: leg.plannedArrival,
				actualDeparture: leg.departure,
				actualArrival: leg.arrival
			)
			return [
				LegViewData.StopViewData(
					name: name ?? leg.origin?.name ?? "origin name",
					timeContainer: c,
					leg: leg,
					type: .footBottom
				)
//				LegViewData.StopViewData(
//					name: name ?? leg.destination?.name ?? "dest name",
//					timeContainer: c,
//					leg: leg,
//
//				)
			]
		case .transfer:
			let c = TimeContainer(
				plannedDeparture: leg.plannedDeparture,
				plannedArrival: leg.plannedArrival,
				actualDeparture: leg.departure,
				actualArrival: leg.arrival
			)
			return [
				LegViewData.StopViewData(
					name: name ?? leg.origin?.name ?? "origin name",
					timeContainer: c,
					leg: leg,
					type: .transfer
				)
//				LegViewData.StopViewData(
//					name: name ?? leg.destination?.name ?? "dest name",
//					timeContainer: c,
//					leg: leg
//				)
			]
		}
	}
}
