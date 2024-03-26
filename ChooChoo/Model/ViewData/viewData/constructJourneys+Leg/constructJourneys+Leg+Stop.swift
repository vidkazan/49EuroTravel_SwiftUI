//
//  constructJourneyList+swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//

import Foundation
import UIKit
import SwiftUI
import CoreLocation


extension LegDTO {
	func stopViewData(type : LegViewData.LegType) -> [StopViewData] {
		switch type {
		case .line:
			let stops = stopovers ?? []
			let res = stops.map { stop -> StopViewData in
				let c = TimeContainer(
					plannedDeparture: stop.plannedDeparture,
					plannedArrival: stop.plannedArrival,
					actualDeparture: stop.departure,
					actualArrival: stop.arrival,
					cancelled: stop.cancelled
				)
				if stop == stops.first {
					return StopViewData(
						name: stop.stop?.name ?? "stop",
						time: c,
						stop: stop,
						type: .origin
					)
				} else if stop == stops.last {
					return StopViewData(
						name: stop.stop?.name ?? "stop",
						time: c,
						stop: stop,
						type: .destination
					)
				} else {
					return StopViewData(
						name: stop.stop?.name ?? "stop",
						time: c,
						stop: stop,
						type: .stopover
					)
				}
			}
			return res
			
		case .footStart(startPointName: let startName):
			let first = TimeContainer(
				plannedDeparture: departure,
				plannedArrival: departure,
				actualDeparture: departure,
				actualArrival: departure,
				cancelled: nil
			)
			let last = TimeContainer(
				plannedDeparture: arrival,
				plannedArrival: arrival,
				actualDeparture: arrival,
				actualArrival: arrival,
				cancelled: nil
			)
			return [
				StopViewData(
					stopId: origin?.id,
					name: startName,
					time: first,
					type: .footTop,
					coordinates: Coordinate(
						latitude: origin?.latitude ?? origin?.location?.latitude ?? 0,
						longitude: origin?.longitude ?? origin?.location?.longitude ?? 0
					)
				),
				StopViewData(
					stopId: destination?.id,
					name: destination?.name ?? "name",
					time: last,
					type: .footTop,
					coordinates: Coordinate(
						latitude: destination?.latitude ?? destination?.location?.latitude ?? 0,
						longitude: destination?.longitude ?? destination?.location?.longitude ?? 0
					)
				)
			]
		case .footMiddle:
			let first = TimeContainer(
				plannedDeparture: departure,
				plannedArrival: departure,
				actualDeparture: departure,
				actualArrival: departure,
				cancelled: nil
			)
			let last = TimeContainer(
				plannedDeparture: arrival,
				plannedArrival: arrival,
				actualDeparture: arrival,
				actualArrival: arrival,
				cancelled: nil
			)
			return [
				StopViewData(
					stopId: origin?.id,
					name: origin?.name ?? "name",
					time: first,
					type: .footMiddle,
					coordinates: Coordinate(
						latitude: origin?.latitude ?? origin?.location?.latitude ?? 0,
						longitude: origin?.longitude ?? origin?.location?.longitude ?? 0
					)
				),
				StopViewData(
					stopId: destination?.id,
					name: destination?.name ?? "name",
					time: last,
					type: .footMiddle,
					coordinates: Coordinate(
						latitude: destination?.latitude ?? destination?.location?.latitude ?? 0,
						longitude: destination?.longitude ?? destination?.location?.longitude ?? 0
					)
				)
			]
		case .footEnd(finishPointName: let endName):
			let first = TimeContainer(
				plannedDeparture: departure,
				plannedArrival: departure,
				actualDeparture: departure,
				actualArrival: departure,
				cancelled: nil
			)
			let last = TimeContainer(
				plannedDeparture: arrival,
				plannedArrival: arrival,
				actualDeparture: arrival,
				actualArrival: arrival,
				cancelled: nil
			)
			return [
				StopViewData(
					stopId: origin?.id,
					name: origin?.name ?? endName,
					time: first,
					type: .footBottom,
					coordinates: Coordinate(
						latitude: origin?.latitude ?? origin?.location?.latitude ?? 0,
						longitude: origin?.longitude ?? origin?.location?.longitude ?? 0
					)
				),
				StopViewData(
					stopId: destination?.id,
					name: endName,
					time: last,
					type: .footBottom,
					coordinates: Coordinate(
						latitude: destination?.latitude ?? destination?.location?.latitude ?? 0,
						longitude: destination?.longitude ?? destination?.location?.longitude ?? 0
					)
				)
			]
		case .transfer:
			let first = TimeContainer(
				plannedDeparture: departure,
				plannedArrival: departure,
				actualDeparture: departure,
				actualArrival: departure,
				cancelled: nil
			)
			let last = TimeContainer(
				plannedDeparture: arrival,
				plannedArrival: arrival,
				actualDeparture: arrival,
				actualArrival: arrival,
				cancelled: nil
			)
			return [
				StopViewData(
					stopId: origin?.id,
					name: origin?.name ?? "name",
					time: first,
					type: .transfer,
					coordinates: Coordinate(
						latitude: origin?.latitude ?? origin?.location?.latitude ?? 0,
						longitude: origin?.longitude ?? origin?.location?.longitude ?? 0
					)
				),
				StopViewData(
					stopId: destination?.id,
					name: destination?.name ?? "name",
					time: last,
					type: .transfer,
					coordinates: Coordinate(
						latitude: destination?.latitude ?? destination?.location?.latitude ?? 0,
						longitude: destination?.longitude ?? destination?.location?.longitude ?? 0
					)
				)
			]
		}
	}
}
