//
//  SearchJourneyVM+ConstructJourneyData.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 07.09.23.
//

import Foundation
import UIKit
import CoreLocation

extension SearchJourneyViewModel {
	
	func constructLegData(leg : Leg,firstTS: Date?, lastTS: Date?,id : Int) -> LegViewDataSourse? {
		guard
			let plannedDepartureTSString = leg.plannedDeparture,
			let plannedArrivalTSString = leg.plannedArrival,
			let actualDepartureTSString = leg.departure,
			let actualArrivalTSString = leg.arrival,
			let lineName = leg.line?.name else { return nil }
		
		let plannedDepartureTS = DateParcer.getDateFromDateString(dateString: plannedDepartureTSString)
		let plannedArrivalTS = DateParcer.getDateFromDateString(dateString: plannedArrivalTSString)
		let actualDepartureTS = DateParcer.getDateFromDateString(dateString: actualDepartureTSString)
		let actualArrivalTS = DateParcer.getDateFromDateString(dateString: actualArrivalTSString)
		
		guard let plannedDeparturePosition = getTimeLabelPosition( firstTS: firstTS, lastTS: lastTS,currentTS: plannedDepartureTS),
			  let actualDeparturePosition = getTimeLabelPosition( firstTS: firstTS, lastTS: lastTS,	currentTS: actualDepartureTS),
			  let plannedArrivalPosition = getTimeLabelPosition( firstTS: firstTS, lastTS: lastTS,	currentTS: plannedArrivalTS),
			  let actualArrivalPosition = getTimeLabelPosition( firstTS: firstTS, lastTS: lastTS,	currentTS: actualArrivalTS) else { return nil }
		
		let res = LegViewDataSourse(
			id: id,
			name: lineName,
			legTopPosition: actualDeparturePosition,
			legBottomPosition: actualArrivalPosition > plannedArrivalPosition ? actualArrivalPosition : plannedArrivalPosition ,
			color: UIColor(hue: 0, saturation: 0, brightness: 0.2, alpha: 1)
		)
		return res
	}
	
	func modifyLegColorDependingOnDelays(currentLeg: LegViewDataSourse?, previousLeg: LegViewDataSourse?) -> Bool{
		guard let currentLeg = currentLeg, let previousLeg = previousLeg else { return false }
		return previousLeg.legBottomPosition > currentLeg.legTopPosition
	}
	
	func constructJourneyCollectionViewData(journey : Journey, firstTS: Date, lastTS: Date,id : Int) -> JourneyCollectionViewDataSourse? {
		var legsDataSourse : [LegViewDataSourse] = []
		guard let legs = journey.legs else { return nil }
		for (index,leg) in legs.enumerated() {
			if var res = self.constructLegData(leg: leg, firstTS: firstTS, lastTS: lastTS,id: index) {
				if legsDataSourse.last != nil && modifyLegColorDependingOnDelays(currentLeg: res, previousLeg: legsDataSourse.last) {
					legsDataSourse[legsDataSourse.count-1].color = UIColor.red
				}
				legsDataSourse.append(res)
			}
		}
		
		let sunEventGenerator = SunEventGenerator(
			locationStart: CLLocationCoordinate2D(
				latitude: self.state.depStop?.location?.latitude ?? 0,
				longitude: self.state.depStop?.location?.longitude ?? 0
			),
			locationFinal : CLLocationCoordinate2D(
				latitude: self.state.arrStop?.location?.latitude ?? 0,
				longitude: self.state.arrStop?.location?.longitude ?? 0
			),
			dateStart: firstTS,
			dateFinal: lastTS)
		
		
		
		return JourneyCollectionViewDataSourse(
			id : id,
			startTimeLabelText: DateParcer.getTimeStringFromDate(date: firstTS),
			endTimeLabelText: DateParcer.getTimeStringFromDate(date: lastTS),
			startDate: firstTS,
			endDate: lastTS,
			durationLabelText: DateParcer.getTimeStringWithHoursAndMinutesFormat(
				minutes: DateParcer.getTwoDateIntervalInMinutes(
					date1: firstTS,
					date2: lastTS)
			) ?? "ololo",
			legs: legsDataSourse,
			sunEvents: sunEventGenerator.getSunEvents()
		)
	}
	
	func constructJourneysCollectionViewData(journeysData : JourneysContainer) -> [JourneyCollectionViewDataSourse] {
		guard let journeys = journeysData.journeys else { return []}
		var journeysViewData : [JourneyCollectionViewDataSourse] = []
		for (index,journey) in journeys.enumerated() {
			guard let journeyLegs = journey.legs else { return []}
			guard let journeyFirstLeg = journeyLegs.first else { return []}
			guard let journeyLastLeg = journeyLegs.last else { return []}
			guard let firstTimestamp = journeyFirstLeg.departure else { return []}
			guard let lastTimestamp = journeyLastLeg.arrival else { return []}
			guard let firstTS = DateParcer.getDateFromDateString(dateString: firstTimestamp) else { return []}
			guard let lastTS = DateParcer.getDateFromDateString(dateString: lastTimestamp) else { return []}
			if let res = self.constructJourneyCollectionViewData(journey: journey, firstTS: firstTS, lastTS: lastTS,id:index) {
				journeysViewData.append(res)
			}
		}
		return journeysViewData
	}
}

extension SearchJourneyViewModel {
	
	func getTimeLabelPosition(firstTS : Date?, lastTS: Date?, currentTS: Date?) -> Double?{
		guard let firstTS = firstTS, let lastTS = lastTS, let currentTS = currentTS else { return nil }
		let fTs = firstTS.timeIntervalSinceReferenceDate
		let lTs = lastTS.timeIntervalSinceReferenceDate
		let cTs = currentTS.timeIntervalSinceReferenceDate
		let ext = 0.0
		let fTsExtended = fTs - ext
		let lTsExtended = lTs + ext
		
		let diffExtended = lTsExtended - fTsExtended
		
		let cDiff = cTs - fTsExtended
		
		return cDiff / diffExtended
	}
	
	private func constructTimelineTimelabelData(firstTS: Date?,lastTS: Date?,currentTS: Date?) -> TimelineTimeLabelDataSourse? {
		guard let firstTS = firstTS, let lastTS = lastTS, let currentTS = currentTS else { return nil }
		let tl = TimelineTimeLabelDataSourse(
			text: DateParcer.getTimeStringFromDate(date: currentTS),
			   textCenterYposition: self.getTimeLabelPosition(
				   firstTS: firstTS,
				   lastTS: lastTS,
				   currentTS: currentTS)!)
		return tl
	}
	
	 func constructTimelineData(firstTS: Date?,lastTS: Date?) -> TimelineViewDataSourse? {
		let tl = TimelineViewDataSourse(timeLabels: [
			self.constructTimelineTimelabelData(firstTS: firstTS, lastTS: lastTS, currentTS: firstTS)!,
			self.constructTimelineTimelabelData(firstTS: firstTS, lastTS: lastTS, currentTS: lastTS)!
		])
		return tl
	}
}
