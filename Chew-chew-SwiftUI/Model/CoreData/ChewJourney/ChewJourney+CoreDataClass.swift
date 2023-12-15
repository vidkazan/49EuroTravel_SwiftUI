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
