//
//  SearchJourneyVM+ConstructJourneyData.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 07.09.23.
//

import Foundation
import CoreLocation
	
func constructJourneysViewData(journeysData : JourneysContainer, depStop : StopType, arrStop : StopType) -> [JourneyViewData] {
	let res = journeysData.journeys.compactMap { (journey) -> JourneyViewData? in
		return constructJourneyViewData(
			journey: journey,
			depStop: depStop,
			arrStop: arrStop
		)
	}
	return res
}
