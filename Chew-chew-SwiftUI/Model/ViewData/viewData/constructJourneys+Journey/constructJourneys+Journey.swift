//
//  ConstructJourneyData+Journey.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//
import Foundation
import CoreLocation
import SwiftUI

extension JourneyDTO {
	func journeyViewDataAsync(
		depStop: Stop?,
		arrStop : Stop?,
		realtimeDataUpdatedAt: Double
	) async -> JourneyViewData? {
		return journeyViewData(
			depStop: depStop,
			arrStop: arrStop,
			realtimeDataUpdatedAt: realtimeDataUpdatedAt
		)
	}

	func journeyViewData(depStop: Stop?,arrStop : Stop?,realtimeDataUpdatedAt: Double) -> JourneyViewData? {
		do {
			return try journeyViewDataThrows(
				depStop: depStop,
				arrStop: arrStop,
				realtimeDataUpdatedAt: realtimeDataUpdatedAt
			)
		} catch  {
			return nil
		}
	}


	func journeyViewDataThrows(
		depStop: Stop?,
		arrStop : Stop?,
		realtimeDataUpdatedAt: Double
	) throws -> JourneyViewData {
		let time = TimeContainer(
			plannedDeparture: legs.first?.plannedDeparture,
			plannedArrival: legs.last?.plannedArrival,
			actualDeparture: legs.first?.departure,
			actualArrival: legs.last?.arrival,
			cancelled: nil
		)
		var isReachable = true
		var legRemarks : [Remark] = (remarks ?? [])
		var legsData : [LegViewData] = []
		let startTS = max(time.date.departure.actual ?? .distantPast, time.date.departure.planned ?? .distantPast)
		let endTS = max(time.date.arrival.planned ?? .distantPast,time.date.arrival.actual ?? .distantPast)
		let legs = legs
		
		for (index,leg) in legs.enumerated() {
			legRemarks += leg.remarks ?? []
			isReachable = leg.reachable ?? true
			if var currentLeg = leg.legViewData(firstTS: startTS, lastTS: endTS, legs: legs) {
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
		
		guard let journeyRef = refreshToken else  {
			throw ConstructDataError.nilValue(type: "journeyRef")
		}
		guard let first = legs.first?.origin,
			  let last = legs.last?.destination else  {
			throw ConstructDataError.nilValue(type: "first or last stop")
		}
		
		return JourneyViewData(
			journeyRef: journeyRef,
			badges: constructBadges(remarks: legRemarks,isReachable: isReachable),
			sunEvents: sunEventService.getSunEvents(),
			legs: legsData,
			depStopName: legs.first?.origin?.name ?? first.address,
			arrStopName: legs.last?.destination?.name ?? last.address,
			time: time,
			updatedAt: realtimeDataUpdatedAt,
			remarks: remarks ?? []
		)
	}
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
