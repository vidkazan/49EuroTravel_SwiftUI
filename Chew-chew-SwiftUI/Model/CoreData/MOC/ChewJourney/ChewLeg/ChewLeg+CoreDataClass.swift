//
//  ChewLeg+CoreDataClass.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 13.12.23.
//
//

import Foundation
import CoreData

@objc(ChewLeg)
public class ChewLeg: NSManagedObject {

}

extension ChewLeg {
	convenience init(context : NSManagedObjectContext,leg : LegViewData,for journey : ChewJourney){
		self.init(context: context)
//		context.performAndWait {
		self.isReachable = leg.isReachable
		self.legBottomPosition = leg.legBottomPosition
		self.legTopPosition = leg.legTopPosition
		self.lineName = leg.lineViewData.name
		self.lineShortName = leg.lineViewData.shortName
		self.lineType = leg.lineViewData.type.rawValue
				
		self.journey = journey
//	}
		let _ = ChewLegType(insertIntoManagedObjectContext: context, type: leg.legType, for: self)
		
		let _ = ChewTime(context: context, container: leg.timeContainer, cancelled: !leg.isReachable,for: self)
		
		for stop in leg.legStopsViewData {
			let _ = ChewStop(insertInto: context, with: stop, to: self)
		}
	}
}

extension ChewLeg {
	func legViewData() -> LegViewData {
		var stopsViewData = [StopViewData]()
		
//		if let stops = self.stops {
			stopsViewData = stops.map {
				$0.stopViewData()
			}
//		}
		let time = TimeContainer(chewTime: self.time)
		let segments = constructSegmentsFromStopOverData(stopovers: stopsViewData)
		return LegViewData(
			isReachable: self.isReachable,
			legType: self.chewLegType.legType ?? .line,
			tripId: nil,
			direction: self.stops.last?.name ?? "direction",
			duration: DateParcer.getTimeStringWithHoursAndMinutesFormat(minutes: time.durationInMinutes) ?? "duration",
			legTopPosition: self.legTopPosition,
			legBottomPosition: self.legBottomPosition,
			remarks: nil,
			legStopsViewData: stopsViewData,
			footDistance: -1,
			lineViewData: LineViewData(
				type: LineType(rawValue: self.lineType) ?? .taxi,
				name: self.lineName,
				shortName: self.lineShortName
			),
			progressSegments: segments,
			timeContainer: time,
			polyline: nil
		)
	}
}
