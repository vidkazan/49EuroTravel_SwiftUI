//
//  SearchJourneyVM+ConstructJourneyData.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 07.09.23.
//

import Foundation
import CoreLocation

func constructJourneysViewDataAsync(journeysData : JourneysContainer, depStop : LocationType, arrStop : LocationType) async -> [JourneyViewData] {
	return constructJourneysViewData(journeysData: journeysData, depStop: depStop, arrStop: arrStop)
}

func constructJourneysViewData(journeysData : JourneysContainer, depStop : LocationType, arrStop : LocationType) -> [JourneyViewData] {
	guard let journeys = journeysData.journeys else { return [] }
	let res = journeys.compactMap { (journey) -> JourneyViewData? in
		return constructJourneyViewData(
			journey: journey,
			depStop: depStop,
			arrStop: arrStop
		)
	}
	return res
}
