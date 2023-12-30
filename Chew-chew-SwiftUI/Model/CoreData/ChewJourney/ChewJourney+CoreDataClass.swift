//
//  ChewJourney+CoreDataClass.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 21.11.23.
//
//

import Foundation
import CoreData

@objc(ChewJourney)
public class ChewJourney: NSManagedObject {

}

extension ChewJourney {
	func journeyViewData() -> JourneyFollowData {
		var legsViewData = [LegViewData]()
		var sunEvents = [SunEvent]()
		
		if let legs = self.legs {
			legsViewData = legs.map {
				$0.legViewData()
			}
		}
		
		if let suns = self.sunEvents {
			sunEvents = suns.map {
				$0.sunEvent()
			}
		}
		
		let time = TimeContainer(chewTime: self.time)
		#warning("add badges")
		return JourneyFollowData(
			journeyRef: self.journeyRef,
			journeyViewData: JourneyViewData(
				journeyRef: journeyRef,
				badges: [],
				sunEvents: sunEvents,
				legs: legsViewData,
				depStopName: departureStop?.name,
				arrStopName: arrivalStop?.name,
				time: time,
				updatedAt: self.updatedAt
			)
		)
	}
}

extension ChewJourney {
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
