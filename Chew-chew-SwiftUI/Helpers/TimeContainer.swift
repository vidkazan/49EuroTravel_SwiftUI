//
//  TimeContainer.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 29.09.23.
//

import Foundation

struct ISOTimeContainer : Equatable, Hashable {
	let plannedDeparture : String?
	let plannedArrival : String?
	let actualDeparture : String?
	let actualArrival : String?
	
	func getDateContainer() -> DateTimeContainer {
//		guard
		let plannedDeparture = DateParcer.getDateFromDateString(dateString: plannedDeparture)
		let plannedArrival = DateParcer.getDateFromDateString(dateString: plannedArrival)
		let actualDeparture = DateParcer.getDateFromDateString(dateString: actualDeparture)
		let actualArrival = DateParcer.getDateFromDateString(dateString: actualArrival)
//		else { return nil }
		return .init(
			plannedDeparture: plannedDeparture,
			plannedArrival: plannedArrival,
			actualDeparture: actualDeparture,
			actualArrival:  actualArrival
		)
	}
}

struct DateTimeContainer : Equatable, Hashable {
	let plannedDeparture : Date?
	let plannedArrival : Date?
	let actualDeparture : Date?
	let actualArrival : Date?
	
	func getTSContainer() -> TimestampTimeContainer {
		return .init(
			plannedDeparture: plannedDeparture?.timeIntervalSince1970,
			plannedArrival: plannedArrival?.timeIntervalSince1970,
			actualDeparture: actualDeparture?.timeIntervalSince1970,
			actualArrival:  actualArrival?.timeIntervalSince1970
		)
	}
}

struct TimestampTimeContainer : Equatable, Hashable {
	let plannedDeparture : Double?
	let plannedArrival : Double?
	let actualDeparture : Double?
	let actualArrival : Double?
}

struct TimeContainer : Equatable, Hashable{
	let iso : ISOTimeContainer
	let date : DateTimeContainer
	let timestamp : TimestampTimeContainer
	
	init(plannedDeparture: String?, plannedArrival: String?, actualDeparture: String?, actualArrival: String?) {
		let pd = plannedDeparture
		let pa = plannedArrival
		let ad = actualDeparture
		let aa = actualArrival
		self.iso = ISOTimeContainer(plannedDeparture: pd, plannedArrival: pa, actualDeparture: ad, actualArrival: aa)
		self.date = self.iso.getDateContainer()
		self.timestamp = self.date.getTSContainer()
	}
	
	func getLegCurrentTimePositionAlongActualDepartureAndArrival(currentTS: Double?) -> Double? {
		guard let firstTS = self.timestamp.actualDeparture, let lastTS = self.timestamp.actualArrival, let currentTS = currentTS else { return nil }
		let fTs = firstTS
		let lTs = lastTS
		let cTs = currentTS
		return (cTs - fTs) / (lTs - fTs) > 0 ? ((cTs - fTs) / (lTs - fTs) > 1 ? 1 : (cTs - fTs) / (lTs - fTs)) : 0
	}
	
	func getStopCurrentTimePositionAlongActualDepartureAndArrival(currentTS: Double?) -> Double? {
		let firstTS : Double = self.timestamp.actualArrival ?? self.timestamp.actualDeparture ?? 0
		let lastTS : Double = self.timestamp.actualDeparture ?? self.timestamp.actualArrival ?? 0
		guard let currentTS = currentTS else { return nil }
		let fTs = firstTS
		let lTs = lastTS
		let cTs = currentTS
		
		return (cTs - fTs) / (lTs - fTs) > 0 ? ((cTs - fTs) / (lTs - fTs) > 1 ? 1 : (cTs - fTs) / (lTs - fTs)) : 0
	}
}
	
