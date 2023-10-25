//
//  constructJourneys+Leg.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//

import Foundation
import UIKit
import SwiftUI
import CoreLocation

func constructLineStopOverData(leg : Leg, type : LegViewData.LegType) -> [StopViewData] {
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
				name: leg.origin?.name ?? "name",
				timeContainer: first,
				type: .footTop,
				coordinates: CLLocationCoordinate2D(
					latitude: leg.origin?.latitude ?? leg.origin?.location?.latitude ?? 0,
					longitude: leg.origin?.longitude ?? leg.origin?.location?.longitude ?? 0
				)
			),
			StopViewData(
				name: leg.destination?.name ?? "name",
				timeContainer: last,
				type: .footTop,
				coordinates: CLLocationCoordinate2D(
					latitude: leg.destination?.latitude ?? leg.destination?.location?.latitude ?? 0,
					longitude: leg.destination?.longitude ?? leg.destination?.location?.longitude ?? 0
				)
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
				name: leg.origin?.name ?? "name",
				timeContainer: first,
				type: .footMiddle,
				coordinates: CLLocationCoordinate2D(
					latitude: leg.origin?.latitude ?? leg.origin?.location?.latitude ?? 0,
					longitude: leg.origin?.longitude ?? leg.origin?.location?.longitude ?? 0
				)
			),
			StopViewData(
				name: leg.destination?.name ?? "name",
				timeContainer: last,
				type: .footMiddle,
				coordinates: CLLocationCoordinate2D(
					latitude: leg.destination?.latitude ?? leg.destination?.location?.latitude ?? 0,
					longitude: leg.destination?.longitude ?? leg.destination?.location?.longitude ?? 0
				)
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
				name: leg.origin?.name ?? "name",
				timeContainer: first,
				type: .footBottom,
				coordinates: CLLocationCoordinate2D(
					latitude: leg.origin?.latitude ?? leg.origin?.location?.latitude ?? 0,
					longitude: leg.origin?.longitude ?? leg.origin?.location?.longitude ?? 0
				)
			),
			StopViewData(
				name: leg.destination?.name ?? "name",
				timeContainer: last,
				type: .footBottom,
				coordinates: CLLocationCoordinate2D(
					latitude: leg.destination?.latitude ?? leg.destination?.location?.latitude ?? 0,
					longitude: leg.destination?.longitude ?? leg.destination?.location?.longitude ?? 0
				)
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
				name: leg.origin?.name ?? "name",
				timeContainer: first,
				type: .transfer,
				coordinates: CLLocationCoordinate2D(
					latitude: leg.origin?.latitude ?? leg.origin?.location?.latitude ?? 0,
					longitude: leg.origin?.longitude ?? leg.origin?.location?.longitude ?? 0
				)
			),
			StopViewData(
				name: leg.destination?.name ?? "name",
				timeContainer: last,
				type: .transfer,
				coordinates: CLLocationCoordinate2D(
					latitude: leg.destination?.latitude ?? leg.destination?.location?.latitude ?? 0,
					longitude: leg.destination?.longitude ?? leg.destination?.location?.longitude ?? 0
				)
			)
		]
	}
}
