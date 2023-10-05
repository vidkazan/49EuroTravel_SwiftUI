//
//  SearchJourneyVM+ConstructJourneyData.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 07.09.23.
//

import Foundation
import CoreLocation

class JourneyViewDataConstructor {
	let journeysData : JourneysContainer
	let depStop : StopType
	let arrStop : StopType
	
	init(data : JourneysContainer,dep : StopType, arr : StopType){
		self.journeysData = data
		self.depStop = dep
		self.arrStop = arr
	}
	
	func constructJourneysViewData(journeysData : JourneysContainer) -> [JourneyViewData] {
		let res = journeysData.journeys.compactMap { (journey) -> JourneyViewData? in
			let container = TimeContainer(
				plannedDeparture: journey.legs.first?.plannedDeparture,
				plannedArrival: journey.legs.last?.plannedArrival,
				actualDeparture: journey.legs.first?.departure,
				actualArrival: journey.legs.last?.arrival
			)
			return constructJourneyViewData(
				journey: journey,
				timeContainer: container,
				firstDelay: journey.legs.first?.departureDelay ?? 0,
				lastDelay: journey.legs.last?.arrivalDelay ?? 0
			)
		}
		return res
	}
}
