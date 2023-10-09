//
//  constructJourneys+Leg.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//

import Foundation
import UIKit
import SwiftUI

	func constructLineStopOverData(leg : Leg, type : LegViewData.LegType) -> [StopViewData] {
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
			let stops = leg.stopovers ?? []
			let res = stops.map { stop -> StopViewData in
				let c = TimeContainer(plannedDeparture: stop.plannedDeparture, plannedArrival: stop.plannedArrival, actualDeparture: stop.departure, actualArrival: stop.arrival,cancelled: stop.cancelled)
				if stop == stops.first {
					return StopViewData(
						name: stop.stop?.name ?? "stop",
						timeContainer: c,
						stop: stop,
						type: .origin
					)
				} else if stop == stops.last {
					return StopViewData(
						name: stop.stop?.name ?? "stop",
						timeContainer: c,
						stop: stop,
						type: .destination
					)
				} else {
					return StopViewData(
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
				plannedDeparture: leg.departure,
				plannedArrival: leg.departure,
				actualDeparture: leg.departure,
				actualArrival: leg.departure,
				cancelled: nil
			)
			let last = TimeContainer(
				plannedDeparture: leg.arrival,
				plannedArrival: leg.arrival,
				actualDeparture: leg.arrival,
				actualArrival: leg.arrival,
				cancelled: nil
			)
			return [
				StopViewData(
					name: name ?? leg.origin?.name ?? "name",
					timeContainer: first,
					type: .footTop,
					coordinates: leg.origin?.location
				),
				StopViewData(
					name: name ?? leg.destination?.name ?? "name",
					timeContainer: last,
					type: .footTop,
					coordinates: leg.destination?.location
				)
			]
		case .footMiddle:
			let first = TimeContainer(
				plannedDeparture: leg.departure,
				plannedArrival: leg.departure,
				actualDeparture: leg.departure,
				actualArrival: leg.departure,
				cancelled: nil
			)
			let last = TimeContainer(
				plannedDeparture: leg.arrival,
				plannedArrival: leg.arrival,
				actualDeparture: leg.arrival,
				actualArrival: leg.arrival,
				cancelled: nil
			)
			return [
				StopViewData(
					name: name ?? leg.origin?.name ?? "name",
					timeContainer: first,
					type: .footMiddle,
					coordinates: leg.origin?.location
				),
				StopViewData(
					name: name ?? leg.destination?.name ?? "name",
					timeContainer: last,
					type: .footMiddle,
					coordinates: leg.destination?.location
				)
			]
		case .footEnd:
			let first = TimeContainer(
				plannedDeparture: leg.departure,
				plannedArrival: leg.departure,
				actualDeparture: leg.departure,
				actualArrival: leg.departure,
				cancelled: nil
			)
			let last = TimeContainer(
				plannedDeparture: leg.arrival,
				plannedArrival: leg.arrival,
				actualDeparture: leg.arrival,
				actualArrival: leg.arrival,
				cancelled: nil
			)
			return [
				StopViewData(
					name: name ?? leg.origin?.name ?? "name",
					timeContainer: first,
					type: .footBottom,
					coordinates: leg.origin?.location
				),
				StopViewData(
					name: name ?? leg.destination?.name ?? "name",
					timeContainer: last,
					type: .footBottom,
					coordinates: leg.destination?.location
				)
			]
		case .transfer:
			let first = TimeContainer(
				plannedDeparture: leg.departure,
				plannedArrival: leg.departure,
				actualDeparture: leg.departure,
				actualArrival: leg.departure,
				cancelled: nil
			)
			let last = TimeContainer(
				plannedDeparture: leg.arrival,
				plannedArrival: leg.arrival,
				actualDeparture: leg.arrival,
				actualArrival: leg.arrival,
				cancelled: nil
			)
			return [
				StopViewData(
					name: name ?? leg.origin?.name ?? "name",
					timeContainer: first,
					type: .transfer,
					coordinates: leg.origin?.location
				),
				StopViewData(
					name: name ?? leg.destination?.name ?? "name",
					timeContainer: last,
					type: .transfer,
					coordinates: leg.destination?.location
				)
			]
		}
	}
