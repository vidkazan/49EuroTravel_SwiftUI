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

func constructTransferViewData(fromLeg : LegDTO, toLeg : LegDTO) -> LegViewData? {
	let first = TimeContainer(
		plannedDeparture: fromLeg.plannedArrival,
		plannedArrival: fromLeg.plannedArrival,
		actualDeparture: fromLeg.arrival,
		actualArrival: fromLeg.arrival,
		cancelled: nil
	)
	let last = TimeContainer(
		plannedDeparture: toLeg.plannedDeparture,
		plannedArrival: toLeg.plannedDeparture,
		actualDeparture: toLeg.departure,
		actualArrival: toLeg.departure,
		cancelled: nil
	)
	let container = TimeContainer(
		plannedDeparture: fromLeg.plannedArrival,
		plannedArrival: toLeg.plannedDeparture,
		actualDeparture: fromLeg.arrival,
		actualArrival: toLeg.departure,
		cancelled: toLeg.reachable
	)
	
	let res = LegViewData(
		isReachable: true,
		legType: .transfer,
		tripId: UUID().uuidString,
		direction: toLeg.origin?.name ?? "transfer direction",
		legTopPosition: 0,
		legBottomPosition: 0,
		delayedAndNextIsNotReachable: toLeg.reachable ?? false,
		remarks: [],
		legStopsViewData: [
			StopViewData(
				name: fromLeg.destination?.name ?? "from",
				time: first,
				type: .transfer,
				coordinates: CLLocationCoordinate2D(
					latitude: fromLeg.destination?.latitude ?? fromLeg.destination?.location?.latitude ?? 0,
					longitude: fromLeg.destination?.longitude ?? fromLeg.destination?.location?.longitude ?? 0
				)
			),
			StopViewData(
				name: toLeg.origin?.name ?? "to",
				time: last,
				type: .transfer,
				coordinates: CLLocationCoordinate2D(
					latitude: toLeg.origin?.latitude ?? toLeg.origin?.location?.latitude ?? 0,
					longitude: toLeg.origin?.longitude ?? toLeg.origin?.location?.longitude ?? 0
				)
			)
		],
		footDistance: 0,
		lineViewData: LineViewData(type: .transfer, name: "transfer", shortName: "transfer"),
		progressSegments: Segments(
			segments: [
				Segments.SegmentPoint(
					time: container.timestamp.departure.actual ?? 0,
					height: 0
				),
				Segments.SegmentPoint(
					time: container.timestamp.arrival.actual ?? 0,
					height: StopOverType.transfer.viewHeight
				)
			],
			heightTotalCollapsed: StopOverType.transfer.viewHeight,
			heightTotalExtended: StopOverType.transfer.viewHeight
		),
		time: container,
		polyline: nil
	)
	return res
}
