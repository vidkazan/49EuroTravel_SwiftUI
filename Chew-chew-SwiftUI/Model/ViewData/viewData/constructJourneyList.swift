//
//  SearchJourneyVM+ConstructJourneyData.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 07.09.23.
//

import Foundation
import CoreLocation

func constructJourneyListViewDataAsync(
	journeysData : JourneyListDTO,
	depStop : Stop,
	arrStop : Stop
) async -> [JourneyViewData] {
	return constructJourneyListViewData(
		journeysData: journeysData,
		depStop: depStop,
		arrStop: arrStop
	)
}

func constructJourneyListViewData(
	journeysData : JourneyListDTO,
	depStop : Stop,
	arrStop : Stop
)  -> [JourneyViewData] {
	guard let journeys = journeysData.journeys else { return [] }
	var res = [JourneyViewData]()
	
	for j in journeys {
		if let data = j.journeyViewData(
			depStop: depStop,
			arrStop: arrStop,
			realtimeDataUpdatedAt: Double(journeysData.realtimeDataUpdatedAt ?? 0)
		) {
			res.append(data)
		}
	}
	return res
}
