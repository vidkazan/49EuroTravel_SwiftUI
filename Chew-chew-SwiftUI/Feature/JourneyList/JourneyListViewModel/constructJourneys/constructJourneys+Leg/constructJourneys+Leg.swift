//
//  constructJourneys+Leg.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//

import Foundation
import UIKit
import SwiftUI

struct LegViewProgressHeights : Equatable, Hashable {
	let totalHeight : CGFloat
	let totalHeightWithStopovers : CGFloat
}

struct Segments : Equatable, Hashable {
	struct SegmentPoint : Equatable, Hashable {
		let time: Double
		let height: CGFloat
	}
	
	var segments: [SegmentPoint]
	
	init(segments: [SegmentPoint]) {
		self.segments = segments
	}
	
	func evaluateExpanded(time: Double) -> Double {
		guard segments.count >= 2 else { return 0.0 }
		
		guard let first = segments.first, let last = segments.last else { return 0 }
		
		if time < first.time { return 0 }
		
		if time > last.time { return last.height }
		
		for i in 0..<segments.count - 1 {
			let currentSegment = segments[i]
			let nextSegment = segments[i + 1]
			
			if time >= currentSegment.time && time <= nextSegment.time {
				let timeFraction = (time - currentSegment.time) / (nextSegment.time - currentSegment.time)
				print(time,currentSegment.height + (nextSegment.height - currentSegment.height) * timeFraction)
				return currentSegment.height + (nextSegment.height - currentSegment.height) * timeFraction
			}
		}
		
		// If time is outside all segments, return a default value or handle it accordingly.
		return 0.0 // You can change this to your desired default value.
	}
	
	func evaluateCollapsed(time: Double) -> Double {
		guard let currentSegment = segments.first,
			  var nextSegment = segments.last else { return 0 }
		
		nextSegment = SegmentPoint(time: nextSegment.time, height: StopOverType.origin.viewHeight)
		
		if time < currentSegment.time { return 0 }
		if time > nextSegment.time { return nextSegment.height }
			if time >= currentSegment.time && time <= nextSegment.time {
				let timeFraction = (time - currentSegment.time) / (nextSegment.time - currentSegment.time)
				return currentSegment.height + (nextSegment.height - currentSegment.height) * timeFraction
			}
		return 0
	}
}

extension JourneyViewDataConstructor {
	func constructSegmentsFromStopOverData(stopovers : [LegViewData.StopViewData]) -> Segments {
		var currentHeight : CGFloat = 0
		var segs = Segments(segments: [])
		
		for stop in stopovers {
			if let time = stop.timeContainer.timestamp.actualArrival {
				segs.segments.append(
					Segments.SegmentPoint(
						time:time,
						height: currentHeight
					)
				)
			}
			currentHeight += stop.type.timeLabelHeight
			if let time = stop.timeContainer.timestamp.actualDeparture {
				segs.segments.append(
					Segments.SegmentPoint(
						time:time,
						height: currentHeight
					)
				)
			}
			currentHeight += (stop.type.viewHeight - stop.type.timeLabelHeight)
		}
		return segs
	}
	
	func constructTransferViewData(fromLeg : Leg, toLeg : Leg, id : Int) -> LegViewData? {
		guard
			let plannedDepartureTSString = fromLeg.plannedArrival,
			let plannedArrivalTSString = toLeg.plannedDeparture,
			let actualDepartureTSString = fromLeg.arrival,
			let actualArrivalTSString =  toLeg.departure else { return nil }
		
		let container = TimeContainer(
			plannedDeparture: plannedDepartureTSString,
			plannedArrival: plannedArrivalTSString,
			actualDeparture: actualDepartureTSString,
			actualArrival: actualArrivalTSString
		)
		
		let dates = container.date
		
//		let plannedDepartureTS = dates.plannedDeparture
//		let plannedArrivalTS = dates.plannedArrival
		let actualDepartureTS = dates.actualDeparture
		let actualArrivalTS = dates.actualArrival
		
		let res = LegViewData(
			id: id,
			fillColor: .clear,
			legType: .transfer,
			direction: "transfer direction",
			duration: DateParcer.getTimeStringWithHoursAndMinutesFormat(
				minutes: DateParcer.getTwoDateIntervalInMinutes(
					date1: actualDepartureTS,
					date2: actualArrivalTS
				)) ?? "duration",
			legTopPosition: 0,
			legBottomPosition: 0,
			delayedAndNextIsNotReachable: nil,
			remarks: [],
			legStopsViewData: [LegViewData.StopViewData(
				name: "transfer",
				timeContainer: container,
				type: .transfer
			)],
			footDistance: 0,
			lineName: "transfer line name",
			heights: LegViewProgressHeights(
				totalHeight: StopOverType.origin.viewHeight,
				totalHeightWithStopovers: StopOverType.origin.viewHeight
			),
			progressSegments: Segments(segments: [
				Segments.SegmentPoint(
					time: container.timestamp.actualDeparture ?? 0,
					height: 0
				),
				Segments.SegmentPoint(
					time: container.timestamp.actualArrival ?? 0,
					height: StopOverType.transfer.viewHeight
				)
			])
		)
		return res
	}
}

extension JourneyViewDataConstructor {
	func constructLegFillColor(leg : Leg) -> Color {
		switch leg.reachable ?? true {
		case true:
			return Color(hue: 0, saturation: 0, brightness: 0.15).opacity(0.75)
		case false:
			return Color(hue: 0, saturation: 1, brightness: 0.4)
		}
	}

	func constructLegData(leg : Leg,firstTS: Date?, lastTS: Date?,id : Int, legs : [Leg]) -> LegViewData? {	
		guard
			let plannedDepartureTSString = leg.plannedDeparture,
			let plannedArrivalTSString = leg.plannedArrival,
			let actualDepartureTSString = leg.departure,
			let actualArrivalTSString = leg.arrival else { return nil }
		
		let plannedDepartureTS = DateParcer.getDateFromDateString(dateString: plannedDepartureTSString)
		let plannedArrivalTS = DateParcer.getDateFromDateString(dateString: plannedArrivalTSString)
		let actualDepartureTS = DateParcer.getDateFromDateString(dateString: actualDepartureTSString)
		let actualArrivalTS = DateParcer.getDateFromDateString(dateString: actualArrivalTSString)
		
		guard let plannedDeparturePosition = JourneyViewDataConstructor.getTimeLabelPosition(firstTS: firstTS, lastTS: lastTS,currentTS: plannedDepartureTS),
			  let actualDeparturePosition = JourneyViewDataConstructor.getTimeLabelPosition( firstTS: firstTS, lastTS: lastTS,	currentTS: actualDepartureTS),
			  let plannedArrivalPosition = JourneyViewDataConstructor.getTimeLabelPosition( firstTS: firstTS, lastTS: lastTS,	currentTS: plannedArrivalTS),
			  let actualArrivalPosition = JourneyViewDataConstructor.getTimeLabelPosition( firstTS: firstTS, lastTS: lastTS,	currentTS: actualArrivalTS) else { return nil }
		
		let stops = constructLineStopOverData(leg: leg, type: constructLegType(leg: leg, legs: legs))
		let segments = constructSegmentsFromStopOverData(stopovers: stops)
		
		
		let res = LegViewData(
			id: id,
			fillColor: constructLegFillColor(leg: leg),
			legType: constructLegType(leg: leg, legs: legs),
			direction: leg.direction ?? "direction",
			duration: DateParcer.getTimeStringWithHoursAndMinutesFormat(
				minutes: DateParcer.getTwoDateIntervalInMinutes(
					date1: actualDepartureTS,
					date2: actualArrivalTS
				)) ?? "duration",
			legTopPosition: max(plannedDeparturePosition,actualDeparturePosition),
			legBottomPosition: max(plannedArrivalPosition,actualArrivalPosition),
			delayedAndNextIsNotReachable: nil,
			remarks: leg.remarks,
			legStopsViewData: stops,
			footDistance: leg.distance ?? 0,
			lineName: leg.line?.name ?? leg.line?.mode ?? "line",
			heights: LegViewProgressHeights(
				totalHeight: StopOverType.origin.viewHeight,
				totalHeightWithStopovers: segments.segments.last?.height ?? 0
			),
			progressSegments: segments
		)
		return res
	}
	
	func currentLegIsNotReachable(currentLeg: LegViewData?, previousLeg: LegViewData?) -> Bool {
		guard let currentLeg = currentLeg, let previousLeg = previousLeg else { return false }
		return previousLeg.legBottomPosition > currentLeg.legTopPosition
	}
}
