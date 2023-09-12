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
	func constructJourneysViewData(journeysData : JourneysContainer,startId : Int = 0) -> [JourneyCollectionViewDataSourse] {
		guard let journeys = journeysData.journeys else { return []}
		var journeysViewData : [JourneyCollectionViewDataSourse] = []
		
		for journey in journeys {
			guard let journeyLegs = journey.legs else { return []}
			guard let journeyFirstLeg = journeyLegs.first else { return []}
			guard let journeyLastLeg = journeyLegs.last else { return []}
			
			guard let firstTimestampPlannedString = journeyFirstLeg.plannedDeparture else { return []}
			guard let firstTimestampActualString = journeyFirstLeg.departure else { return []}
			
			guard let lastTimestampPlannedString = journeyLastLeg.plannedArrival else { return []}
			guard let lastTimestampActualString = journeyLastLeg.arrival else { return []}
			
			guard let firstTimestampPlannedDate = DateParcer.getDateFromDateString(dateString: firstTimestampPlannedString) else { return []}
			guard let lastTimestampPlannedDate = DateParcer.getDateFromDateString(dateString: lastTimestampPlannedString) else { return []}
			guard let firstTimestampActualDate = DateParcer.getDateFromDateString(dateString: firstTimestampActualString) else { return []}
			guard let lastTimestampActualDate = DateParcer.getDateFromDateString(dateString: lastTimestampActualString) else { return []}
			if let res = constructJourneyViewData(
				journey: journey,
				firstTSPlanned: firstTimestampPlannedDate,
				firstTSActual: firstTimestampActualDate,
				lastTSPlanned:  lastTimestampPlannedDate,
				lastTSActual: lastTimestampActualDate
			) {
				journeysViewData.append(res)
			}
		}
		return journeysViewData
	}
}

