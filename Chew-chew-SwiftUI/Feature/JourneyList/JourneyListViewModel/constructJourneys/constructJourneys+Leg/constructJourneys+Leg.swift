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
			timeContainer: container
		)
		return res
	}

func constructLineViewData(mode : String,product : String, name : String, productName : String) -> LineViewData{
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
				return .other(type: mode)
			}
		}()
		return LineViewData(
			type: mode,
			name: name,
			shortName: productName
		)
	}

	func constructLegData(leg : Leg,firstTS: Date?, lastTS: Date?, legs : [Leg]) -> LegViewData? {
		let container = TimeContainer(
			plannedDeparture: leg.plannedDeparture,
			plannedArrival: leg.plannedArrival,
			actualDeparture: leg.departure,
			actualArrival: leg.arrival
		)
		
		guard let plannedDeparturePosition = getTimeLabelPosition(firstTS: firstTS, lastTS: lastTS,currentTS: container.date.departure.planned),
			  let actualDeparturePosition = getTimeLabelPosition( firstTS: firstTS, lastTS: lastTS,	currentTS: container.date.departure.actual),
			  let plannedArrivalPosition = getTimeLabelPosition( firstTS: firstTS, lastTS: lastTS,	currentTS: container.date.arrival.planned),
			  let actualArrivalPosition = getTimeLabelPosition( firstTS: firstTS, lastTS: lastTS,	currentTS: container.date.arrival.actual) else { return nil }
		
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
			lineViewData: constructLineViewData(
				mode: leg.line?.mode ?? "",
				product: leg.line?.product ?? "",
				name: leg.line?.name ?? "",
				productName: leg.line?.productName ?? ""
			),
			progressSegments: segments,
			timeContainer: container
		)
		return res
	}
	
	func currentLegIsNotReachable(currentLeg: LegViewData?, previousLeg: LegViewData?) -> Bool {
		guard let currentLeg = currentLeg, let previousLeg = previousLeg else { return false }
		return previousLeg.legBottomPosition > currentLeg.legTopPosition
	}
