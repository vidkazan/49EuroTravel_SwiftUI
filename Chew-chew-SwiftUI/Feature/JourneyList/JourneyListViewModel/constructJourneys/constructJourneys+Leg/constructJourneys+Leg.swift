//
//  constructJourneys+Leg.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//

import Foundation
import UIKit
import SwiftUI

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
			last = SegmentPoint(time: last.time, height: StopOverType.origin.viewHeight)
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

extension JourneyViewDataConstructor {
	func constructSegmentsFromStopOverData(stopovers : [StopViewData]) -> Segments {
		var currentHeight : CGFloat = 0
		var segs = [Segments.SegmentPoint]()
		
		for stop in stopovers {
			if let time = stop.timeContainer.timestamp.arrival.actual {
				segs.append(
					Segments.SegmentPoint(
						time:time,
						height: currentHeight
					)
				)
			}
			currentHeight += stop.type.timeLabelHeight
			if let time = stop.timeContainer.timestamp.departure.actual {
				segs.append(
					Segments.SegmentPoint(
						time:time,
						height: currentHeight
					)
				)
			}
			currentHeight += (stop.type.viewHeight - stop.type.timeLabelHeight)
		}
		
		return Segments(
			segments: segs,
			heightTotalCollapsed: stopovers.first?.type.viewHeight ?? 0,
			heightTotalExtended: segs.last?.height ?? 0
		)
	}
	
	func constructTransferViewData(fromLeg : Leg, toLeg : Leg) -> LegViewData? {
		let container = TimeContainer(
			plannedDeparture: fromLeg.plannedArrival,
			plannedArrival: toLeg.plannedDeparture,
			actualDeparture: fromLeg.arrival,
			actualArrival: toLeg.departure
		)
		
		let res = LegViewData(
			isReachable: true,
			legType: .transfer,
			direction: "transfer direction",
			duration: DateParcer.getTimeStringWithHoursAndMinutesFormat(
				minutes: DateParcer.getTwoDateIntervalInMinutes(
					date1: container.date.departure.actual,
					date2: container.date.arrival.actual
				)) ?? "duration",
			legTopPosition: 0,
			legBottomPosition: 0,
			delayedAndNextIsNotReachable: nil,
			remarks: [],
			legStopsViewData: [StopViewData(
				name: "transfer",
				timeContainer: container,
				type: .transfer
			)],
			footDistance: 0,
			lineName: "transfer line name",
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
			timeContainer: container
		)
		return res
	}
}

extension JourneyViewDataConstructor {

	func constructLegData(leg : Leg,firstTS: Date?, lastTS: Date?, legs : [Leg]) -> LegViewData? {
		let container = TimeContainer(
			plannedDeparture: leg.plannedDeparture,
			plannedArrival: leg.plannedArrival,
			actualDeparture: leg.departure,
			actualArrival: leg.arrival
		)
		
		guard let plannedDeparturePosition = JourneyViewDataConstructor.getTimeLabelPosition(firstTS: firstTS, lastTS: lastTS,currentTS: container.date.departure.planned),
			  let actualDeparturePosition = JourneyViewDataConstructor.getTimeLabelPosition( firstTS: firstTS, lastTS: lastTS,	currentTS: container.date.departure.actual),
			  let plannedArrivalPosition = JourneyViewDataConstructor.getTimeLabelPosition( firstTS: firstTS, lastTS: lastTS,	currentTS: container.date.arrival.planned),
			  let actualArrivalPosition = JourneyViewDataConstructor.getTimeLabelPosition( firstTS: firstTS, lastTS: lastTS,	currentTS: container.date.arrival.actual) else { return nil }
		
		let stops = constructLineStopOverData(leg: leg, type: constructLegType(leg: leg, legs: legs))
		let segments = constructSegmentsFromStopOverData(stopovers: stops)
		
		let res = LegViewData(
			isReachable: leg.reachable ?? true,
			legType: constructLegType(leg: leg, legs: legs),
			direction: leg.direction ?? "direction",
			duration: DateParcer.getTimeStringWithHoursAndMinutesFormat(
				minutes: DateParcer.getTwoDateIntervalInMinutes(
					date1: container.date.departure.actual,
					date2: container.date.arrival.actual
				)) ?? "duration",
			legTopPosition: max(plannedDeparturePosition,actualDeparturePosition),
			legBottomPosition: max(plannedArrivalPosition,actualArrivalPosition),
			delayedAndNextIsNotReachable: nil,
			remarks: leg.remarks,
			legStopsViewData: stops,
			footDistance: leg.distance ?? 0,
			lineName: leg.line?.name ?? leg.line?.mode ?? "line",
			progressSegments: segments,
			timeContainer: container
		)
		return res
	}
	
	func currentLegIsNotReachable(currentLeg: LegViewData?, previousLeg: LegViewData?) -> Bool {
		guard let currentLeg = currentLeg, let previousLeg = previousLeg else { return false }
		return previousLeg.legBottomPosition > currentLeg.legTopPosition
	}
}
