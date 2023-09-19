//
//  ConstructJourneyData+Journey.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//
import Foundation
import CoreLocation
import UIKit


extension JourneyListViewModel {
	func constructJourneyViewData(journey : Journey,firstTSPlanned: Date,firstTSActual: Date,lastTSPlanned: Date,lastTSActual: Date
	) -> JourneyCollectionViewDataSourse {
		var isReachable = true
		var remarks : [Remark] = []
		var legsDataSourse : [LegViewDataSourse] = []
		let startTS = max(firstTSActual, firstTSPlanned)
		let endTS = max(lastTSActual,lastTSPlanned)
		let legs = journey.legs ?? []
		remarks = journey.remarks ?? []
		
		for (index,leg) in legs.enumerated() {
			remarks += leg.remarks ?? .init()
			if leg.reachable == false {
				isReachable = false
			}
			if let res = self.constructLegData(leg: leg, firstTS: startTS, lastTS: endTS,id: index) {
				if legsDataSourse.last != nil && currentLegIsNotReachable(currentLeg: res, previousLeg: legsDataSourse.last) {
					legsDataSourse[legsDataSourse.count-1].delayedAndNextIsNotReachable = true
					isReachable = false
				}
				legsDataSourse.append(res)
			}
		}
		let sunEventGenerator = SunEventGenerator(
			locationStart: CLLocationCoordinate2D(
				latitude: depStop.stop.location?.latitude ?? 0,
				longitude: depStop.stop.location?.longitude ?? 0
			),
			locationFinal : CLLocationCoordinate2D(
				latitude: arrStop.stop.location?.latitude ?? 0,
				longitude: arrStop.stop.location?.longitude ?? 0
			),
			dateStart: startTS,
			dateFinal: endTS)
		
		return JourneyCollectionViewDataSourse(
			id : journey.id,
			startPlannedTimeDate: firstTSPlanned,
			startActualTimeDate: firstTSActual,
			endPlannedTimeDate: lastTSPlanned,
			endActualTimeDate: lastTSActual,
			startDate: firstTSPlanned,
			endDate: lastTSPlanned,
			durationLabelText: DateParcer.getTimeStringWithHoursAndMinutesFormat(
				minutes: DateParcer.getTwoDateIntervalInMinutes(
					date1: firstTSActual,
					date2: lastTSActual)
			) ?? "error", legDTO: journey.legs,
			legs: legsDataSourse.reversed(),
			sunEvents: sunEventGenerator.getSunEvents(),
			isReachable: isReachable,
			badges: constructBadges(remarks: remarks,isReachable: isReachable),
			refreshToken: journey.refreshToken
		)
	}
	
}
