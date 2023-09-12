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
	func constructJourneyViewData(
		journey : Journey,
		firstTSPlanned: Date,
		firstTSActual: Date,
		lastTSPlanned: Date,
		lastTSActual: Date
	) -> JourneyCollectionViewDataSourse? {
		var isReachable = true
		var legsDataSourse : [LegViewDataSourse] = []
		guard let legs = journey.legs else { return nil }
		for (index,leg) in legs.enumerated() {
			if leg.reachable == false {
				isReachable = false
			}
			if let res = self.constructLegData(leg: leg, firstTS: firstTSPlanned, lastTS: lastTSPlanned,id: index) {
				if legsDataSourse.last != nil && currentLegIsReachable(currentLeg: res, previousLeg: legsDataSourse.last) {
					legsDataSourse[legsDataSourse.count-1].delayedAndNextIsNotReachable = true
					isReachable = false
				}
				legsDataSourse.append(res)
			}
		}
		
		let sunEventGenerator = SunEventGenerator(
			locationStart: CLLocationCoordinate2D(
				latitude: depStop.location?.latitude ?? 0,
				longitude: depStop.location?.longitude ?? 0
			),
			locationFinal : CLLocationCoordinate2D(
				latitude: arrStop.location?.latitude ?? 0,
				longitude: arrStop.location?.longitude ?? 0
			),
			dateStart: firstTSPlanned < firstTSActual ? firstTSPlanned : firstTSActual,
			dateFinal: lastTSPlanned > lastTSActual ? lastTSPlanned : lastTSActual )
		
		return JourneyCollectionViewDataSourse(
			id : journey.id,
			startPlannedTimeLabelText: DateParcer.getTimeStringFromDate(date: firstTSPlanned),
			startActualTimeLabelText: firstTSActual == firstTSPlanned ? "" : DateParcer.getTimeStringFromDate(date: firstTSActual),
			endPlannedTimeLabelText: DateParcer.getTimeStringFromDate(date: lastTSPlanned),
			endActualTimeLabelText: lastTSActual == lastTSPlanned ? "" : DateParcer.getTimeStringFromDate(date: lastTSActual),
			startDate: firstTSPlanned,
			endDate: lastTSPlanned,
			durationLabelText: DateParcer.getTimeStringWithHoursAndMinutesFormat(
				minutes: DateParcer.getTwoDateIntervalInMinutes(
					date1: firstTSActual,
					date2: lastTSActual)
			) ?? "error",
			legs: legsDataSourse.reversed(),
			sunEvents: sunEventGenerator.getSunEvents(),
			isReachable: isReachable
		)
	}
	
}
