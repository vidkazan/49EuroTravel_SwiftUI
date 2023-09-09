//
//  ConstructJourneyData+Journey.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//
import Foundation
import CoreLocation
import UIKit

extension SearchJourneyViewModel {
	func constructJourneyViewData(
		journey : Journey,
		firstTSPlanned: Date,
		firstTSActual: Date,
		lastTSPlanned: Date,
		lastTSActual: Date,
		id : Int
	) -> JourneyCollectionViewDataSourse? {
		var legsDataSourse : [LegViewDataSourse] = []
		guard let legs = journey.legs else { return nil }
		for (index,leg) in legs.enumerated() {
			if var res = self.constructLegData(leg: leg, firstTS: firstTSPlanned, lastTS: lastTSPlanned,id: index) {
				if legsDataSourse.last != nil && modifyLegColorDependingOnDelays(currentLeg: res, previousLeg: legsDataSourse.last) {
					legsDataSourse[legsDataSourse.count-1].delayedAndNextIsNotReachable = true
				}
				legsDataSourse.append(res)
			}
		}
		
		let sunEventGenerator = SunEventGenerator(
			locationStart: CLLocationCoordinate2D(
				latitude: self.state.depStop?.location?.latitude ?? 0,
				longitude: self.state.depStop?.location?.longitude ?? 0
			),
			locationFinal : CLLocationCoordinate2D(
				latitude: self.state.arrStop?.location?.latitude ?? 0,
				longitude: self.state.arrStop?.location?.longitude ?? 0
			),
			dateStart: firstTSPlanned < firstTSActual ? firstTSPlanned : firstTSActual,
			dateFinal: lastTSPlanned > lastTSActual ? lastTSPlanned : lastTSActual )
		
		return JourneyCollectionViewDataSourse(
			id : id,
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
			legs: legsDataSourse,
			sunEvents: sunEventGenerator.getSunEvents()
		)
	}
	
}
