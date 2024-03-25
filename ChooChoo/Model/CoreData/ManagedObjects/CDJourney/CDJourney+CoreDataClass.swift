//
//  CDJourney+CoreDataClass.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 21.11.23.
//
//

import Foundation
import CoreData

@objc(CDJourney)
public class CDJourney: NSManagedObject {

}

extension CDJourney {
	func journeyFollowData() -> JourneyFollowData {
		var legsViewData = [LegViewData]()
		var sunEvents = [SunEvent]()
		var data : JourneyFollowData!
		self.managedObjectContext?.performAndWait {
			legsViewData = legs.map {
				$0.legViewData()
			}
			
			sunEvents = self.sunEvents.map {
				$0.sunEvent()
			}
			let time = TimeContainer(isoEncoded: self.time) ?? .init()
//			let time = TimeContainer(chewTime: self.time)
			#warning("add remarks")
			data = JourneyFollowData(
				id : self.id,
				journeyViewData: JourneyViewData(
					journeyRef: journeyRef,
					badges: [],
					sunEvents: sunEvents,
					legs: legsViewData,
					depStopName: departureStop.name,
					arrStopName: arrivalStop.name,
					time: time,
					updatedAt: self.updatedAt,
					remarks: [],
					settings: JourneySettings()
				),
				depStop: self.departureStop.stop(),
				arrStop: self.arrivalStop.stop()
			)
			
		}
		return data
	}
}
