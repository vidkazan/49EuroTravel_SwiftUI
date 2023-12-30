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
		
		self.isReachable = leg.isReachable
		self.legBottomPosition = leg.legBottomPosition
		self.legTopPosition = leg.legTopPosition
		self.lineName = leg.lineViewData.name
		self.lineShortName = leg.lineViewData.shortName
		self.lineType = leg.lineViewData.type.rawValue
		self.journey = journey
		
		let _ = ChewLegType(insertIntoManagedObjectContext: context, type: leg.legType, for: self)
		
		let _ = ChewTime(context: context, container: leg.timeContainer, cancelled: !leg.isReachable,for: self)
		
//		for stop in leg.legStopsViewData {
//			let _ = ChewStop(insertInto: context, with: stop, to: self)
//		}
		
		do {
			try context.save()
		} catch {
			let nserror = error as NSError
			print("📕 > save \(Self.self): failed to save new ", nserror.localizedDescription)
		}
	}
}

extension ChewLeg {
	static func updateWith(
		of obj : ChewLeg?,
		with leg : LegViewData,
		using managedObjectContext: NSManagedObjectContext
	) {
		guard let obj = obj else { return }
		
		obj.isReachable = leg.isReachable
		obj.legBottomPosition = leg.legBottomPosition
		obj.legTopPosition = leg.legTopPosition
		obj.lineName = leg.lineViewData.name
		obj.lineShortName = leg.lineViewData.shortName
		obj.lineType = leg.lineViewData.type.rawValue
		
		ChewTime.updateWith(
			container: leg.timeContainer,
			isCancelled: !leg.isReachable,
			using: managedObjectContext,
			chewTime: obj.time
		)
		
		ChewLegType.updateWith(
			of: obj.chewLegType,
			with: leg.legType,
			using: managedObjectContext
		)
		
		if let stops = obj.stops {
			for stop in stops {
				ChewStop.delete(object: stop, in: managedObjectContext)
			}
		}
		
		for stop in leg.legStopsViewData {
			let _ = ChewStop(insertInto: managedObjectContext, with: stop, to: obj)
		}
		
		do {
			try managedObjectContext.save()
		} catch {
			let nserror = error as NSError
			print("📕 > update \(Self.self): fialed to update", nserror.localizedDescription)
		}
	}
}

extension ChewLeg {
	func legViewData() -> LegViewData {
		var stopsViewData = [StopViewData]()
		
		if let stops = self.stops {
			stopsViewData = stops.map {
				$0.stopViewData()
			}
		}
		let time = TimeContainer(chewTime: self.time)
		let segments = constructSegmentsFromStopOverData(stopovers: stopsViewData)
		return LegViewData(
			isReachable: self.isReachable,
			legType: self.chewLegType?.legType ?? .line,
			tripId: nil,
			direction: self.stops?.last?.name ?? "direction",
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
