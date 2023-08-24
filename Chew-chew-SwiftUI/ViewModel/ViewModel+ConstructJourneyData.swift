//
//  ViewModel+ConstructJourneyData.swift
//  49EuroTravel
//
//  Created by Dmitrii Grigorev on 09.08.23.
//

import Foundation
import SwiftUI

extension SearchLocationViewModel {
	
	func constructLegData(leg : Leg,firstTS: Date?, lastTS: Date?) -> LegViewDataSourse? {
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
			name: lineName,
			legTopPosition: actualDeparturePosition,
			legBottomPosition: actualArrivalPosition > plannedArrivalPosition ? actualArrivalPosition : plannedArrivalPosition ,
			color: .darkGray
		)
		return res
	}
	
	func modifyLegColorDependingOnDelays(currentLeg: LegViewDataSourse?, previousLeg: LegViewDataSourse?) -> Bool{
		guard let currentLeg = currentLeg, let previousLeg = previousLeg else { return false }
		return previousLeg.legBottomPosition > currentLeg.legTopPosition
	}
	
	func constructJourneyCollectionViewData(journey : Journey, firstTS: Date, lastTS: Date) -> JourneyCollectionViewDataSourse? {
		var legsDataSourse : [LegViewDataSourse] = []
		guard let legs = journey.legs else { return nil }
		for leg in legs {
			if var res = self.constructLegData(leg: leg, firstTS: firstTS, lastTS: lastTS) {
				if legsDataSourse.last != nil && modifyLegColorDependingOnDelays(currentLeg: res, previousLeg: legsDataSourse.last) {
					legsDataSourse[legsDataSourse.count-1].color = UIColor.red
				}
				legsDataSourse.append(res)
			}
		}
		return JourneyCollectionViewDataSourse(
			startTimeLabelText: DateParcer.getTimeStringFromDate(date: firstTS),
			endTimeLabelText: DateParcer.getTimeStringFromDate(date: lastTS),
			durationLabelText: DateParcer.getTimeStringWithHoursAndMinutesFormat(
				minutes: DateParcer.getTwoDateIntervalInMinutes(
					date1: firstTS,
					date2: lastTS)
			)!,
			legs: legsDataSourse
		)
	}
	
	func constructJourneysCollectionViewData(){
		guard let src = self.journeysData else { return }
		guard let journeys = src.journeys else { return }
		var journeysViewData : [JourneyCollectionViewDataSourse] = []
		for journey in journeys {
			guard let journeyLegs = journey.legs else { return }
			guard let journeyFirstLeg = journeyLegs.first else { return }
			guard let journeyLastLeg = journeyLegs.last else { return }
			guard let firstTimestamp = journeyFirstLeg.departure else { return }
			guard let lastTimestamp = journeyLastLeg.arrival else { return }
			guard let firstTS = DateParcer.getDateFromDateString(dateString: firstTimestamp) else { return }
			guard let lastTS = DateParcer.getDateFromDateString(dateString: lastTimestamp) else { return }
			if let res = self.constructJourneyCollectionViewData(journey: journey, firstTS: firstTS, lastTS: lastTS) {
				journeysViewData.append(res)
			}
		}
		self.resultJourneysCollectionViewDataSourse = AllJourneysCollectionViewDataSourse(
			awaitingData: false,
			journeys: journeysViewData
		)
	}
}


//	func constructJourneyData(journey : Journey, firstTS: Date?, lastTS: Date?) -> JourneyViewDataSourse? {
//		var legsDataSourse : [LegViewDataSourse] = []
//		guard let legs = journey.legs else { return nil }
//		for leg in legs {
//			if var res = self.constructLegData(leg: leg, firstTS: firstTS, lastTS: lastTS) {
//				if legsDataSourse.last != nil && modifyLegColorDependingOnDelays(currentLeg: res, previousLeg: legsDataSourse.last) {
//					legsDataSourse[legsDataSourse.count-1].color = UIColor.CompanionColors.red
//				}
//				legsDataSourse.append(res)
//			}
//		}
//		return JourneyViewDataSourse(legs: legsDataSourse)
//	}
	
//	func constructJourneysData(){
//		guard let src = self.journeysData else { return }
//		guard let journeys = src.journeys else { return }
//		guard let firstJourney = journeys.first else { return }
//		guard let lastJourney = journeys.last else { return }
//		guard let firstJourneyLegs = firstJourney.legs else { return }
//		guard let lastJourneyLegs = lastJourney.legs else { return }
//
//		guard let firstJourneyFirstLeg = firstJourneyLegs.first else { return }
//		guard let firstJourneyLastLeg = firstJourneyLegs.last else { return }
//		guard let lastJourneyLastLeg = lastJourneyLegs.last else { return }
//
//
//		guard let firstTimestamp = firstJourneyFirstLeg.plannedDeparture else { return }
//		guard let lastTimestampFirstTrip = firstJourneyLastLeg.plannedArrival else { return }
//		guard let lastTimestamp = lastJourneyLastLeg.plannedArrival else { return }
//
//		let firstTS = DateParcer.getDateFromDateString(dateString: firstTimestamp)
//		let lastFromFirstJourneyTS = DateParcer.getDateFromDateString(dateString: lastTimestampFirstTrip)
//		let lastTS = DateParcer.getDateFromDateString(dateString: lastTimestamp)
//
//		var journeysViewData : [JourneyViewDataSourse] = []
//		for journey in journeys {
//		if let res = self.constructJourneyData(journey: journey, firstTS: firstTS, lastTS: lastTS) {
//				journeysViewData.append(res)
//			}
//		}
//
//		guard let tl = self.constructTimelineData(firstTS: firstTS, lastTS: lastTS) else { return }
//		prints("pixels per journey / pixels per all journeys")
//		prints(Double(UIScreen.main.bounds.height) / Double(DateParcer.getTwoDateIntervalInMinutes(date1: lastTS, date2: firstTS)!),
//			   Double(UIScreen.main.bounds.height) / Double(DateParcer.getTwoDateIntervalInMinutes(date1: lastFromFirstJourneyTS, date2: firstTS)!))
//
//		self.resultJourneysViewDataSourse = ResultJourneyViewDataSourse(
//			awaitingData: false,
//			journeys: journeysViewData,
//			timeline: tl
//		)
//	}
