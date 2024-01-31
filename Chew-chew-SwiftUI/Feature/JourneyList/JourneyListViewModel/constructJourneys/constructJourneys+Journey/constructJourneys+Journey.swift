//
//  ConstructJourneyData+Journey.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//
import Foundation
import CoreLocation
import SwiftUI


func constructJourneyViewDataAsync(
	journey : JourneyDTO,
	depStop: Stop?,
	arrStop : Stop?,
	realtimeDataUpdatedAt: Double
) async -> JourneyViewData? {
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
) -> JourneyViewData? {
	do {
		return try constructJourneyViewDataThrows(
			journey: journey,
			depStop: depStop,
			arrStop: arrStop,
			realtimeDataUpdatedAt: realtimeDataUpdatedAt
		)
	} catch  {
		return nil
	}
}

func constructJourneyViewDataThrows(
	journey : JourneyDTO,
	depStop: Stop?,
	arrStop : Stop?,
	realtimeDataUpdatedAt: Double
) throws -> JourneyViewData {
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
		if var currentLeg = constructLegData(leg: leg, firstTS: startTS, lastTS: endTS, legs: legs) {
			if let last = legsData.last {
				if currentLegIsNotReachable(
					currentLeg: currentLeg,
					previousLeg: last
				) == true {
					legsData[legsData.count-1].delayedAndNextIsNotReachable = true
					isReachable = false
					currentLeg.isReachable = false
				}
				if case .line = currentLeg.legType, case .line = last.legType {
					if let transfer = constructTransferViewData(fromLeg: legs[index-1], toLeg: leg) {
						legsData.append(transfer)
					}
				}
			}
			legsData.append(currentLeg)
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
	
	guard let journeyRef = journey.refreshToken else  {
		throw ConstructDataError.nilValue(type: "journeyRef")
	}
	return JourneyViewData(
		journeyRef: journeyRef,
		badges: constructBadges(remarks: remarks,isReachable: isReachable),
		sunEvents: sunEventService.getSunEvents(),
		legs: legsData,
		depStopName: journey.legs.first?.origin?.name ?? journey.legs.first?.origin?.address ?? "Origin(journeyViewData)",
		arrStopName: journey.legs.last?.destination?.name ?? journey.legs.last?.destination?.address ?? "Destination(journeyViewData)",
		time: timeContainer,
		updatedAt: realtimeDataUpdatedAt
	)
}



func getGradientStops(startDateTS : Double?, endDateTS : Double?,sunEvents : [SunEvent] ) -> [Gradient.Stop] {
	let nightColor = Color.chewFillBluePrimary
	let dayColor = Color.chewFillYellowPrimary
	var stops : [Gradient.Stop] = []
	for event in sunEvents {
		if
			let startDateTS = startDateTS,
			let endDateTS = endDateTS {
			switch event.type {
			case .sunrise:
				stops.append(Gradient.Stop(
					color: nightColor,
					location: (event.timeStart.timeIntervalSince1970 - startDateTS) / (endDateTS - startDateTS)
				))
				if let final = event.timeFinal {
					stops.append(Gradient.Stop(
						color: dayColor,
						location: (final.timeIntervalSince1970 - startDateTS) / (endDateTS - startDateTS)
					))
				}
			case .day:
				stops.append(Gradient.Stop(
					color: dayColor,
					location: 0
				))
			case .sunset:
				stops.append(Gradient.Stop(
					color: dayColor,
					location: (event.timeStart.timeIntervalSince1970 - startDateTS) / (endDateTS - startDateTS)
				))
				if let final = event.timeFinal {
					stops.append(Gradient.Stop(
						color: nightColor,
						location:  (final.timeIntervalSince1970 - startDateTS) / (endDateTS - startDateTS)
					))
				}
			case .night:
				stops.append(Gradient.Stop(
					color: nightColor,
					location: 0
				))
			}
		}
	}
	return stops.sorted(by: {$0.location < $1.location})
}
