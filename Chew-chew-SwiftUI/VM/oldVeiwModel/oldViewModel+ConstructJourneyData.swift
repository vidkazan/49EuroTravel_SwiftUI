//
//  ViewModel+ConstructJourneyData.swift
//  49EuroTravel
//
//  Created by Dmitrii Grigorev on 09.08.23.
//

import Foundation
import SwiftUI
import CoreLocation

extension OldSearchLocationViewModel {
	
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
				latitude: self.journeySearchData.departureStop?.stop.location?.latitude ?? 0,
				longitude: self.journeySearchData.departureStop?.stop.location?.longitude ?? 0
			),
			locationFinal : CLLocationCoordinate2D(
				latitude: self.journeySearchData.arrivalStop?.stop.location?.latitude ?? 0,
				longitude: self.journeySearchData.arrivalStop?.stop.location?.longitude ?? 0
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
	
	func constructJourneysCollectionViewData(){
		guard let src = self.journeysData else { return }
		guard let journeys = src.journeys else { return }
		var journeysViewData : [JourneyCollectionViewDataSourse] = []
		for (index,journey) in journeys.enumerated() {
			guard let journeyLegs = journey.legs else { return }
			guard let journeyFirstLeg = journeyLegs.first else { return }
			guard let journeyLastLeg = journeyLegs.last else { return }
			guard let firstTimestamp = journeyFirstLeg.departure else { return }
			guard let lastTimestamp = journeyLastLeg.arrival else { return }
			guard let firstTS = DateParcer.getDateFromDateString(dateString: firstTimestamp) else { return }
			guard let lastTS = DateParcer.getDateFromDateString(dateString: lastTimestamp) else { return }
			if let res = self.constructJourneyCollectionViewData(journey: journey, firstTS: firstTS, lastTS: lastTS,id:index) {
				journeysViewData.append(res)
			}
		}
		self.resultJourneysCollectionViewDataSourse = AllJourneysCollectionViewDataSourse(
			journeys: journeysViewData
		)
	}
}