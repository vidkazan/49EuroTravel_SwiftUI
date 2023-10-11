//
//  ConstructJourneyData+Journey.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//
import Foundation
import CoreLocation

func constructJourneyViewData(
	journey : Journey,
	depStop: StopType?,
	arrStop : StopType?
) -> JourneyViewData {
	let timeContainer = TimeContainer(
		plannedDeparture: journey.legs.first?.plannedDeparture,
		plannedArrival: journey.legs.last?.plannedArrival,
		actualDeparture: journey.legs.first?.departure,
		actualArrival: journey.legs.last?.arrival,
		cancelled: nil
	)
	var isReachable = true
	var remarks : [Remark] = []
	var legsData : [LegViewData] = []
	let startTS = max(timeContainer.date.departure.actual ?? .now, timeContainer.date.departure.planned ?? .now)
	let endTS = max(timeContainer.date.arrival.planned ?? .now,timeContainer.date.arrival.actual ?? .now)
	let legs = journey.legs
	remarks = journey.remarks ?? []
	
	for (index,leg) in legs.enumerated() {
		remarks += leg.remarks ?? []
		if leg.reachable == false {
			isReachable = false
		}
		if let res = constructLegData(leg: leg, firstTS: startTS, lastTS: endTS, legs: legs) {
			if let last = legsData.last {
				if currentLegIsNotReachable(currentLeg: res, previousLeg: last) {
					legsData[legsData.count-1].delayedAndNextIsNotReachable = true
					isReachable = false
				}
				if case .line = res.legType, case .line = last.legType {
					if let transfer = constructTransferViewData(fromLeg: legs[index-1], toLeg: leg) {
						legsData.append(transfer)
					}
				}
			}
			legsData.append(res)
		}
	}
	let sunEventGenerator = SunEventGenerator(
		locationStart: CLLocationCoordinate2D(
			latitude: depStop?.stop.location?.latitude ?? 0,
			longitude: depStop?.stop.location?.longitude ?? 0
		),
		locationFinal : CLLocationCoordinate2D(
			latitude: arrStop?.stop.location?.latitude ?? 0,
			longitude: arrStop?.stop.location?.longitude ?? 0
		),
		dateStart: startTS,
		dateFinal: endTS)
		
	return JourneyViewData(
		origin: journey.legs.first?.origin?.name ?? "Origin",
		destination: journey.legs.last?.destination?.name ?? "Destination",
		startDateString: DateParcer.getDateOnlyStringFromDate(date: timeContainer.date.departure.actual ?? .now),
		endDateString: DateParcer.getDateOnlyStringFromDate(date: timeContainer.date.arrival.actual ?? .now),
		durationLabelText: DateParcer.getTimeStringWithHoursAndMinutesFormat(
			minutes: DateParcer.getTwoDateIntervalInMinutes(
				date1: timeContainer.date.departure.actual,
				date2: timeContainer.date.arrival.actual)
		) ?? "error",
		legs: legsData,
		transferCount: constructTransferCount(legs: legsData),
		sunEvents: sunEventGenerator.getSunEvents(),
		isReachable: isReachable,
		badges: constructBadges(remarks: remarks,isReachable: isReachable),
		refreshToken: journey.refreshToken,
		timeContainer: timeContainer
	)
}
