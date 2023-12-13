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
				origin: self.departureStop?.name ?? "origin",
				destination: self.arrivalStop?.name ?? "destination",
				durationLabelText: DateParcer.getTimeStringWithHoursAndMinutesFormat(minutes: time.durationInMinutes) ?? "duration",
				legs: legsViewData,
				transferCount: constructTransferCount(legs: legsViewData),
				sunEvents: sunEvents,
				isReachable: true,
				badges: [],
				refreshToken: self.journeyRef,
				timeContainer: time
			)
		)
	}
}
