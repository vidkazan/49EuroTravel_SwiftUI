//
//  TimeContainer.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 29.09.23.
//

// TODO: add date string to time container
import Foundation

// MARK: TimeContainer
struct TimeContainer : Equatable{
	enum Status : Equatable {
		case onTime
		case delay(Int)
		case cancelled
		
		var value : Int? {
			switch self {
			case .cancelled:
				return nil
			case .delay(let d):
				return d
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
	let departureDelay : Status
	let arrivalDelay : Status
}
extension TimeContainer {
	// MARK: Init
	init(plannedDeparture: String?, plannedArrival: String?, actualDeparture: String?, actualArrival: String?, cancelled : Bool?) {
		let departure = PrognoseType(
			actual: actualDeparture,
			planned: plannedDeparture
		)
		let arrival = PrognoseType(
			actual: actualArrival,
			planned: plannedArrival
		)
		self.iso = ISOTimeContainer(departure: departure,arrival: arrival)
		self.date = self.iso.getDateContainer()
		self.timestamp = self.date.getTSContainer()
		self.stringTimeValue = self.date.getStringTimeValueContainer()
		self.stringDateValue = self.date.getStringDateValueContainer()
		self.departureDelay = self.timestamp.generateDelayStatus(type: .departure, cancelled: cancelled)
		self.arrivalDelay = self.timestamp.generateDelayStatus(type: .arrival, cancelled:  cancelled)
	}
	// MARK: ISO Container
	struct ISOTimeContainer : Equatable {
		let departure : PrognoseType<String?>
		let arrival : PrognoseType<String?>
		
		func getDateContainer() -> DateTimeContainer {
			return DateTimeContainer(
				departure: PrognoseType(
					actual: DateParcer.getDateFromDateString(dateString: departure.actual),
					planned: DateParcer.getDateFromDateString(dateString: departure.planned)
				),
				arrival: PrognoseType(
					actual: DateParcer.getDateFromDateString(dateString: arrival.actual),
					planned: DateParcer.getDateFromDateString(dateString: arrival.planned)
				)
			)
		}
	}
	// MARK: Date Container
	struct DateTimeContainer : Equatable {
		let departure : PrognoseType<Date?>
		let arrival : PrognoseType<Date?>
		
		func getTSContainer() -> TimestampTimeContainer {
			return TimestampTimeContainer(
				departure: PrognoseType(
					actual: departure.actual?.timeIntervalSince1970,
					planned: departure.planned?.timeIntervalSince1970
				),
				arrival: PrognoseType(
					actual: arrival.actual?.timeIntervalSince1970,
					planned: arrival.planned?.timeIntervalSince1970
				)
			)
		}
		func getStringTimeValueContainer() -> TimeStringContainer {
			return TimeStringContainer(
				departure: PrognoseType(
					actual: DateParcer.getTimeStringFromDate(date: departure.actual),
					planned: DateParcer.getTimeStringFromDate(date: departure.planned)
				),
				arrival: PrognoseType(
					actual: DateParcer.getTimeStringFromDate(date: arrival.actual),
					planned: DateParcer.getTimeStringFromDate(date: arrival.planned)
				)
			)
		}
		func getStringDateValueContainer() -> DateStringContainer {
			return DateStringContainer(
				departure: PrognoseType(
					actual: DateParcer.getDateOnlyStringFromDate(date: departure.actual),
					planned: DateParcer.getDateOnlyStringFromDate(date: departure.planned)
				),
				arrival: PrognoseType(
					actual: DateParcer.getDateOnlyStringFromDate(date: arrival.actual),
					planned: DateParcer.getDateOnlyStringFromDate(date: arrival.planned)
				)
			)
		}
	}
	
	// MARK: TimeString Container
	struct TimeStringContainer : Equatable {
		let departure : PrognoseType<String?>
		let arrival : PrognoseType<String?>
	}
	struct DateStringContainer : Equatable {
		let departure : PrognoseType<String?>
		let arrival : PrognoseType<String?>
	}
	// MARK: TS Container
	struct TimestampTimeContainer : Equatable {
		let departure : PrognoseType<Double?>
		let arrival : PrognoseType<Double?>
		
		func generateDelayStatus(type: LocationDirectionType, cancelled : Bool?) -> Status {
			let time : PrognoseType<Double?> = {
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

