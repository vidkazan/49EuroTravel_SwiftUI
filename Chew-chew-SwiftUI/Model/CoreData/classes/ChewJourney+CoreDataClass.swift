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
	
		if let legs = self.legs {
		legsViewData = legs.map {
				$0.legViewData()
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
				transferCount: 0,
				sunEvents: [],
				isReachable: true,
				badges: [],
				refreshToken: self.journeyRef,
				timeContainer: time
			)
		)
	}
}
