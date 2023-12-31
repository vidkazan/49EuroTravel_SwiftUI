//
//  ConstructJourneyData+Journey.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//
import Foundation
import CoreLocation

func constructJourneyViewDataAsync(
	journey : JourneyDTO,
	depStop: Stop?,
	arrStop : Stop?,
	realtimeDataUpdatedAt: Double
) async -> JourneyViewData {
	return constructJourneyViewData(
		journey: journey,
		depStop: depStop,
		arrStop: arrStop,
		realtimeDataUpdatedAt: realtimeDataUpdatedAt
	)
}
func constructJourneyViewData(
	journey : JourneyDTO,
	depStop: Stop?,
	arrStop : Stop?,
	realtimeDataUpdatedAt: Double
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
		isReachable = leg.reachable ?? true
		if let res = constructLegData(leg: leg, firstTS: startTS, lastTS: endTS, legs: legs) {
			if let last = legsData.last {
				if currentLegIsNotReachable(currentLeg: res, previousLeg: last) == true {
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
	let sunEventService = SunEventService(
		locationStart: CLLocationCoordinate2D(
			latitude: depStop?.coordinates.latitude ?? 0,
			longitude: depStop?.coordinates.longitude ?? 0
		),
		locationFinal : CLLocationCoordinate2D(
			latitude: arrStop?.coordinates.latitude ?? 0,
			longitude: arrStop?.coordinates.longitude ?? 0
		),
		dateStart: startTS,
		dateFinal: endTS
	)
	
	return JourneyViewData(
		origin: journey.legs.first?.origin?.name ?? journey.legs.first?.origin?.address ?? "Origin(journeyViewData)",
		destination: journey.legs.last?.destination?.name ?? journey.legs.last?.destination?.address ?? "Destination(journeyViewData)",
		durationLabelText: DateParcer.getTimeStringWithHoursAndMinutesFormat(minutes: timeContainer.durationInMinutes) ?? "duration",
		legs: legsData,
		transferCount: constructTransferCount(legs: legsData),
		sunEvents: sunEventService.getSunEvents(),
		isReachable: isReachable,
		badges: constructBadges(remarks: remarks,isReachable: isReachable),
		refreshToken: journey.refreshToken,
		timeContainer: timeContainer,
		updatedAt: realtimeDataUpdatedAt
	)
}
