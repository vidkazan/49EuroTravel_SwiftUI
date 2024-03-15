//
//  Segments.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 06.02.24.
//

import Foundation

struct Segments : Equatable, Hashable {
	enum ShowType : Int, Equatable, Hashable, CaseIterable {
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
	
	func heightTotal(_ type : ShowType) -> Double {
		switch type {
		case .collapsed:
			return heightTotalCollapsed
		case .expanded:
			return heightTotalExtended
		}
	}
	
	init(segments: [SegmentPoint], heightTotalCollapsed: Double, heightTotalExtended: Double) {
		self.segments = segments
		self.heightTotalCollapsed = heightTotalCollapsed
		self.heightTotalExtended = heightTotalExtended
	}
	
	func update(time: Double, type: ShowType) -> Double {
		guard
			let first = segments.first,
			var last = segments.last,
			time >= first.time else { return 0 }
		
		if case .collapsed = type {
			last = SegmentPoint(time: last.time, height: self.heightTotalCollapsed)
		}
		if time > last.time {
			return last.height
		}
		
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
	
	private func getHeight(
		time : Double,
		currentSegment: SegmentPoint,
		nextSegment : SegmentPoint
	) -> Double? {
		if time >= currentSegment.time && time <= nextSegment.time {
			let timeFraction = (time - currentSegment.time) / (nextSegment.time - currentSegment.time)
			return currentSegment.height + (nextSegment.height - currentSegment.height) * timeFraction
		}
		return nil
	}
}

func segments(from stopovers : [StopViewData]) -> Segments {
	var heightTotalCollapsed : Double?
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
		
		if stopovers.first?.cancellationType() != .fullyCancelled, stopovers.last?.cancellationType() != .fullyCancelled {
			heightTotalCollapsed = stopovers.first?.stopOverType.viewHeight
		}
	}
	
	return Segments(
		segments: segs,
		heightTotalCollapsed: heightTotalCollapsed ?? 0,
		heightTotalExtended: segs.last?.height ?? 0
	)
}

