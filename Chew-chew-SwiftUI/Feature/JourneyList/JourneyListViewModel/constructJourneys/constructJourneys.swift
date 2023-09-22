//
//  SearchJourneyVM+ConstructJourneyData.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 07.09.23.
//

import Foundation
import UIKit
import CoreLocation

extension JourneyListViewModel {
	func constructJourneysViewData(journeysData : JourneysContainer) -> [JourneyViewData] {
		let res = journeysData.journeys?.compactMap { (journey) -> JourneyViewData? in
			constructJourneyViewData(
				journey: journey,
				firstTSPlanned: DateParcer.getDateFromDateString(
					dateString: journey.legs?.first?.plannedDeparture) ?? .now,
				firstTSActual: DateParcer.getDateFromDateString(
					dateString: journey.legs?.first?.departure) ?? .now,
				lastTSPlanned: DateParcer.getDateFromDateString(
					dateString: journey.legs?.last?.plannedArrival) ?? .now,
				lastTSActual: DateParcer.getDateFromDateString(
					dateString: journey.legs?.last?.arrival) ?? .now,
				firstDelay: journey.legs?.first?.departureDelay ?? 0,
				lastDelay: journey.legs?.last?.arrivalDelay ?? 0
			)
		}
		return res ?? []
	}
}
