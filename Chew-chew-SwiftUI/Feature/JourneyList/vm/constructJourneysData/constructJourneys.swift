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
	func constructJourneysViewData(journeysData : JourneysContainer) -> [JourneyCollectionViewData] {
		let res = journeysData.journeys?.compactMap { (journey) -> JourneyCollectionViewData? in
			constructJourneyViewData(
				journey: journey,
				firstTSPlanned: DateParcer.getDateFromDateString(
					dateString: journey.legs?.first?.plannedDeparture) ?? .now,
				firstTSActual: DateParcer.getDateFromDateString(
					dateString: journey.legs?.first?.departure) ?? .now,
				lastTSPlanned: DateParcer.getDateFromDateString(
					dateString: journey.legs?.last?.plannedArrival) ?? .now,
				lastTSActual: DateParcer.getDateFromDateString(
					dateString: journey.legs?.last?.arrival) ?? .now
			)
		}
		return res ?? []
	}
}
