//
//  TimeContainer.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 29.09.23.
//

import Foundation

// MARK: TimeContainer
struct TimeContainer : Equatable {
	enum DelayStatus : Equatable {
		case onTime
		case delay(Int)
		case cancelled
		
		var value : Int? {
			switch self {
			case .cancelled:
				return nil
			case .delay(let time):
				return time
			case .onTime:
				return 0
			}
		}
	}
	
	let iso : ISOTimeContainer
	let date : DateTimeContainer
	let timestamp : TimestampTimeContainer
	let stringTimeValue : TimeStringContainer
	let stringDateValue : DateStringContainer
	let departureStatus : DelayStatus
	let arrivalStatus : DelayStatus
	let durationInMinutes : Int
}

extension TimeContainer {
	// MARK: Init
	init(chewTime : ChewTime?) {
		self.init(
			plannedDeparture: chewTime?.plannedDeparture,
			plannedArrival: chewTime?.plannedArrival,
			actualDeparture: chewTime?.actualDeparture,
			actualArrival: chewTime?.actualArrival,
			cancelled: chewTime?.cancelled
		)
	}
	init() {
		let departure = PrognosedTime<String?>(
			actual: nil,
			planned: nil
		)
		let arrival = PrognosedTime<String?>(
			actual: nil,
			planned: nil
		)
		self.iso = ISOTimeContainer(departure: departure,arrival: arrival)
		self.date = self.iso.getDateContainer()
		self.timestamp = self.date.getTSContainer()
		self.stringTimeValue = self.date.getStringTimeValueContainer()
		self.stringDateValue = self.date.getStringDateValueContainer()
		self.departureStatus = self.timestamp.generateDelayStatus(type: .departure, cancelled: false)
		self.arrivalStatus = self.timestamp.generateDelayStatus(type: .arrival, cancelled: false)
		self.durationInMinutes = -1
	}
	
	init(
		plannedDeparture: String?,
		plannedArrival: String?,
		actualDeparture: String?,
		actualArrival: String?,
		cancelled : Bool?
	) {
		let departure = PrognosedTime(
			actual: actualDeparture,
			planned: plannedDeparture
		)
		let arrival = PrognosedTime(
			actual: actualArrival,
			planned: plannedArrival
		)
		self.iso = ISOTimeContainer(departure: departure,arrival: arrival)
		self.date = self.iso.getDateContainer()
		self.timestamp = self.date.getTSContainer()
		self.stringTimeValue = self.date.getStringTimeValueContainer()
		self.stringDateValue = self.date.getStringDateValueContainer()
		self.departureStatus = self.timestamp.generateDelayStatus(type: .departure, cancelled: cancelled)
		self.arrivalStatus = self.timestamp.generateDelayStatus(type: .arrival, cancelled:  cancelled)
		self.durationInMinutes = DateParcer.getTwoDateIntervalInMinutes(date1: self.date.departure.actual, date2: self.date.arrival.actual) ?? -1
	}
}

extension TimeContainer {
	// MARK: ISO Container
	struct ISOTimeContainer : Equatable {
		let departure : PrognosedTime<String?>
		let arrival : PrognosedTime<String?>
		
		func getDateContainer() -> DateTimeContainer {
			return DateTimeContainer(
				departure: PrognosedTime(
					actual: DateParcer.getDateFromDateString(dateString: departure.actual),
					planned: DateParcer.getDateFromDateString(dateString: departure.planned)
				),
				arrival: PrognosedTime(
					actual: DateParcer.getDateFromDateString(dateString: arrival.actual),
					planned: DateParcer.getDateFromDateString(dateString: arrival.planned)
				)
			)
		}
	}
	// MARK: Date Container
	struct DateTimeContainer : Equatable {
		let departure : PrognosedTime<Date?>
		let arrival : PrognosedTime<Date?>
		
		func getTSContainer() -> TimestampTimeContainer {
			return TimestampTimeContainer(
				departure: PrognosedTime(
					actual: departure.actual?.timeIntervalSince1970,
					planned: departure.planned?.timeIntervalSince1970
				),
				arrival: PrognosedTime(
					actual: arrival.actual?.timeIntervalSince1970,
					planned: arrival.planned?.timeIntervalSince1970
				)
			)
		}
		func getStringTimeValueContainer() -> TimeStringContainer {
			return TimeStringContainer(
				departure: PrognosedTime(
					actual: DateParcer.getTimeStringFromDate(date: departure.actual),
					planned: DateParcer.getTimeStringFromDate(date: departure.planned)
				),
				arrival: PrognosedTime(
					actual: DateParcer.getTimeStringFromDate(date: arrival.actual),
					planned: DateParcer.getTimeStringFromDate(date: arrival.planned)
				)
			)
		}
		func getStringDateValueContainer() -> DateStringContainer {
			return DateStringContainer(
				departure: PrognosedTime(
					actual: DateParcer.getDateOnlyStringFromDate(date: departure.actual),
					planned: DateParcer.getDateOnlyStringFromDate(date: departure.planned)
				),
				arrival: PrognosedTime(
					actual: DateParcer.getDateOnlyStringFromDate(date: arrival.actual),
					planned: DateParcer.getDateOnlyStringFromDate(date: arrival.planned)
				)
			)
		}
	}
	
	// MARK: TimeString Container
	struct TimeStringContainer : Equatable {
		let departure : PrognosedTime<String?>
		let arrival : PrognosedTime<String?>
	}
	struct DateStringContainer : Equatable {
		let departure : PrognosedTime<String?>
		let arrival : PrognosedTime<String?>
	}
	// MARK: TS Container
	struct TimestampTimeContainer : Equatable {
		let departure : PrognosedTime<Double?>
		let arrival : PrognosedTime<Double?>
		
		func generateDelayStatus(type: LocationDirectionType, cancelled : Bool?) -> DelayStatus {
			let time : PrognosedTime<Double?> = {
				switch type {
				case .departure:
					return self.departure
				case .arrival:
					return self.arrival
				}
			}()
			
			if cancelled == true && time.actual == nil {
				return .cancelled
			}
			
			let delay = Int((time.actual ?? 0) - (time.planned ?? 0)) / 60
			if delay >= 1 {
				return .delay(delay)
			} else {
				return .onTime
			}
		}
	}
	
	func getStopCurrentTimePositionAlongActualDepartureAndArrival(currentTS: Double?) -> Double? {
		let fTs : Double = self.timestamp.arrival.actual ?? self.timestamp.departure.actual ?? 0
		let lTs : Double = self.timestamp.departure.actual ?? self.timestamp.arrival.actual ?? 0
		guard let cTs = currentTS else { return nil }
		
		let res = (cTs - fTs) / (lTs - fTs)
		
		return res > 0 ? (res > 1 ? 1 : res) : 0
	}
}

