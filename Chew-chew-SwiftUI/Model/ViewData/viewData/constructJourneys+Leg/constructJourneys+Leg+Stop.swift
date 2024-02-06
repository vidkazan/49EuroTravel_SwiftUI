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
					name: startName,
					time: first,
					type: .footTop,
					coordinates: CLLocationCoordinate2D(
						latitude: origin?.latitude ?? origin?.location?.latitude ?? 0,
						longitude: origin?.longitude ?? origin?.location?.longitude ?? 0
					)
				),
				StopViewData(
					name: destination?.name ?? "name",
					time: last,
					type: .footTop,
					coordinates: CLLocationCoordinate2D(
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
					name: origin?.name ?? "name",
					time: first,
					type: .footMiddle,
					coordinates: CLLocationCoordinate2D(
						latitude: origin?.latitude ?? origin?.location?.latitude ?? 0,
						longitude: origin?.longitude ?? origin?.location?.longitude ?? 0
					)
				),
				StopViewData(
					name: destination?.name ?? "name",
					time: last,
					type: .footMiddle,
					coordinates: CLLocationCoordinate2D(
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
					name: origin?.name ?? endName,
					time: first,
					type: .footBottom,
					coordinates: CLLocationCoordinate2D(
						latitude: origin?.latitude ?? origin?.location?.latitude ?? 0,
						longitude: origin?.longitude ?? origin?.location?.longitude ?? 0
					)
				),
				StopViewData(
					name: endName,
					time: last,
					type: .footBottom,
					coordinates: CLLocationCoordinate2D(
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
					name: origin?.name ?? "name",
					time: first,
					type: .transfer,
					coordinates: CLLocationCoordinate2D(
						latitude: origin?.latitude ?? origin?.location?.latitude ?? 0,
						longitude: origin?.longitude ?? origin?.location?.longitude ?? 0
					)
				),
				StopViewData(
					name: destination?.name ?? "name",
					time: last,
					type: .transfer,
					coordinates: CLLocationCoordinate2D(
						latitude: destination?.latitude ?? destination?.location?.latitude ?? 0,
						longitude: destination?.longitude ?? destination?.location?.longitude ?? 0
					)
				)
			]
		}
	}
}
