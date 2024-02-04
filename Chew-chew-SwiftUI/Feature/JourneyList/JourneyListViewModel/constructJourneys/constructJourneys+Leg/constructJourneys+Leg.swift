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

struct Segments : Equatable, Hashable {
	enum EvalType : Int,Equatable, Hashable {
		case collapsed
		case expanded
	}
	
	struct SegmentPoint : Equatable, Hashable {
		let time: Double
		let height: Double
	}
	
	var segments: [SegmentPoint]
	let heightTotalCollapsed : Double
	let heightTotalExtended : Double
	
	init(segments: [SegmentPoint], heightTotalCollapsed: Double, heightTotalExtended: Double) {
		self.segments = segments
		self.heightTotalCollapsed = heightTotalCollapsed
		self.heightTotalExtended = heightTotalExtended
	}
	
	func evaluate(time: Double, type: EvalType) -> Double {
		guard
			let first = segments.first,
			var last = segments.last,
			time >= first.time else { return 0 }
		
		if case .collapsed = type {
			last = SegmentPoint(time: last.time, height: self.heightTotalCollapsed)
		}
		if time > last.time { return last.height }
		
		switch type {
		case .collapsed:
			if let res = getHeight(time: time, currentSegment: first, nextSegment: last) {
				return res
			}
		case .expanded:
			for i in 0..<segments.count - 1 {
				let currentSegment = segments[i]
				let nextSegment = segments[i + 1]
				
				if let res = getHeight(time: time, currentSegment: currentSegment, nextSegment: nextSegment) {
					return res
				}
			}
		}
		return 0
	}
	
	private func getHeight(time : Double,currentSegment: SegmentPoint, nextSegment : SegmentPoint) -> Double? {
		if time >= currentSegment.time && time <= nextSegment.time {
			let timeFraction = (time - currentSegment.time) / (nextSegment.time - currentSegment.time)
			return currentSegment.height + (nextSegment.height - currentSegment.height) * timeFraction
		}
		return nil
	}
}

func constructSegmentsFromStopOverData(stopovers : [StopViewData]) -> Segments {
	var currentHeight : CGFloat = 0
	var segs = [Segments.SegmentPoint]()
	
	for stop in stopovers {
		if let time = stop.time.timestamp.arrival.actual {
			segs.append(
				Segments.SegmentPoint(
					time:time,
					height: currentHeight
				)
			)
		}
		currentHeight += stop.stopOverType.timeLabelHeight
		if let time = stop.time.timestamp.departure.actual {
			segs.append(
				Segments.SegmentPoint(
					time:time,
					height: currentHeight
				)
			)
		}
		currentHeight += (stop.stopOverType.viewHeight - stop.stopOverType.timeLabelHeight)
	}
	
	return Segments(
		segments: segs,
		heightTotalCollapsed: stopovers.first?.stopOverType.viewHeight ?? 0,
		heightTotalExtended: segs.last?.height ?? 0
	)
}

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
		duration: DateParcer.getTimeStringWithHoursAndMinutesFormat(
			minutes: DateParcer.getTwoDateIntervalInMinutes(
				date1: container.date.departure.actual,
				date2: container.date.arrival.actual
			)) ?? "duration",
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

func constructLineViewData(mode : String,product : String, name : String, productName : String
) -> LineViewData {
	let mode : LineType = {
		switch product {
		case "nationalExpress":
			return .nationalExpress
		case "national":
			return .national
		case "regionalExpress":
			return .regionalExpress
		case "regional":
			return .regional
		case "suburban":
			return .suburban
		case "bus":
			return .bus
		case "ferry":
			return .ferry
		case "subway":
			return .subway
		case "tram":
			return .tram
		case "taxi":
			return .taxi
		default:
			return .taxi
		}
	}()
	return LineViewData(
		type: mode,
		name: name,
		shortName: productName
	)
}

func constructLegData(leg : LegDTO,firstTS: Date?, lastTS: Date?, legs : [LegDTO]?) -> LegViewData? {
	do {
		return try constructLegDataThrows(leg: leg, firstTS: firstTS, lastTS: lastTS, legs: legs)
	} catch  {
		return nil
	}
}

func constructLegDataThrows(leg : LegDTO,firstTS: Date?, lastTS: Date?, legs : [LegDTO]?) throws -> LegViewData {
	let container = TimeContainer(
		plannedDeparture: leg.plannedDeparture,
		plannedArrival: leg.plannedArrival,
		actualDeparture: leg.departure,
		actualArrival: leg.arrival,
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
	
	
	guard let tripId = leg.walking == true ? UUID().uuidString : leg.tripId else  {
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
	
	let stops = constructLineStopOverData(leg: leg, type: constructLegType(leg: leg, legs: legs))
	let segments = constructSegmentsFromStopOverData(stopovers: stops)
	
	let res = LegViewData(
		isReachable: stops.allSatisfy({$0.cancellationType() != .fullyCancelled}) &&  stops.first?.cancellationType() != .fullyCancelled && stops.last?.cancellationType() != .fullyCancelled,
		legType: constructLegType(leg: leg, legs: legs),
		tripId: tripId,
		direction: leg.direction ?? "direction",
		duration: DateParcer.getTimeStringWithHoursAndMinutesFormat(
			minutes: DateParcer.getTwoDateIntervalInMinutes(
				date1: container.date.departure.actual,
				date2: container.date.arrival.actual
			)) ?? DateParcer.getTimeStringWithHoursAndMinutesFormat(
				minutes: DateParcer.getTwoDateIntervalInMinutes(
				 date1: container.date.departure.planned,
				 date2: container.date.arrival.planned
			 )) ?? "duration",
		legTopPosition: max(plannedDeparturePosition,actualDeparturePosition),
		legBottomPosition: max(plannedArrivalPosition,actualArrivalPosition),
		delayedAndNextIsNotReachable: nil,
		remarks: leg.remarks,
		legStopsViewData: stops,
		footDistance: leg.distance ?? 0,
		lineViewData: constructLineViewData(
			mode: leg.line?.mode ?? "mode",
			product: leg.line?.product ?? "product",
			name: leg.line?.name ?? "lineName",
			productName: leg.line?.productName ?? "productName"
		),
		progressSegments: segments,
		time: container,
		polyline: leg.polyline
	)
	return res
}

func currentLegIsNotReachable(currentLeg: LegViewData?, previousLeg: LegViewData?) -> Bool? {
	guard let currentLeg = currentLeg?.time.timestamp.departure.actual,
			let previousLeg = previousLeg?.time.timestamp.arrival.actual else { return nil }
	return previousLeg > currentLeg
}
