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
		lastTSActual: Date,
		firstDelay : Int,
		lastDelay : Int
	) -> JourneyViewData {
		var isReachable = true
		var remarks : [Remark] = []
		var legsData : [LegViewData] = []
		let startTS = max(firstTSActual, firstTSPlanned)
		let endTS = max(lastTSActual,lastTSPlanned)
		let legs = journey.legs ?? []
		remarks = journey.remarks ?? []
		
		for (index,leg) in legs.enumerated() {
			remarks += leg.remarks ?? .init()
			if leg.reachable == false {
				isReachable = false
			}
			if let res = self.constructLegData(leg: leg, firstTS: startTS, lastTS: endTS,id: index, legs: legs) {
				if legsData.last != nil && currentLegIsNotReachable(currentLeg: res, previousLeg: legsData.last) {
					legsData[legsData.count-1].delayedAndNextIsNotReachable = true
					isReachable = false
				}
				legsData.append(res)
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
		
		return JourneyViewData(
			id : journey.id,
			origin: journey.legs?.first?.origin?.name ?? "Origin",
			destination: journey.legs?.last?.destination?.name ?? "Destination",
			startPlannedTimeString: DateParcer.getTimeStringFromDate(date: firstTSPlanned) ?? "time",
			startActualTimeString: DateParcer.getTimeStringFromDate(date: firstTSActual) ?? "time",
			endPlannedTimeString: DateParcer.getTimeStringFromDate(date: lastTSPlanned) ?? "time",
			endActualTimeString: DateParcer.getTimeStringFromDate(date: lastTSActual) ?? "time",
			startDelay: firstDelay,
			endDelay: lastDelay,
			startDate: firstTSActual,
			endDate: lastTSActual,
			startDateString: DateParcer.getDateOnlyStringFromDate(date: firstTSActual),
			endDateString: DateParcer.getDateOnlyStringFromDate(date: lastTSActual),
			durationLabelText: DateParcer.getTimeStringWithHoursAndMinutesFormat(
				minutes: DateParcer.getTwoDateIntervalInMinutes(
					date1: firstTSActual,
					date2: lastTSActual)
			) ?? "error",
			legDTO: journey.legs,
			legs: legsData,
			transferCount: constructTransferCount(legs: legsData),
			sunEvents: sunEventGenerator.getSunEvents(),
			isReachable: isReachable,
			badges: constructBadges(remarks: remarks,isReachable: isReachable),
			refreshToken: journey.refreshToken
		)
	}
	
}
