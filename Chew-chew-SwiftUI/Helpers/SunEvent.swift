//
//  SunEvent.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 30.08.23.
//

import Foundation
import CoreLocation

enum SunEventType : Equatable {
	case sunrise
	case day
	case sunset
	case night
}

struct SunEvent : Equatable {
	static func == (lhs: SunEvent, rhs: SunEvent) -> Bool {
		return
			lhs.type == rhs.type &&
		lhs.timeStart == rhs.timeStart &&
		lhs.timeFinal == rhs.timeFinal
		
	}
	
	let type : SunEventType
	let location : CLLocationCoordinate2D
	let timeStart : Date
	let timeFinal : Date?
	
	init(type: SunEventType, location: CLLocationCoordinate2D, timeStart: Date, timeFinal: Date?) {
		self.type = type
		self.location = location
		self.timeStart = timeStart
		self.timeFinal = timeFinal
		
	}
}

class SunEventGenerator {
	private let locationStart : CLLocationCoordinate2D
	private let locationFinal: CLLocationCoordinate2D
	private let dateStart : Date
	private let dateFinal : Date
	private let duration : Double?
	
	init(locationStart: CLLocationCoordinate2D, locationFinal: CLLocationCoordinate2D, dateStart: Date, dateFinal: Date) {
		self.locationStart = locationStart
		self.locationFinal = locationFinal
		self.dateStart = dateStart
		self.dateFinal = dateFinal
		
		self.duration = DateParcer.getTwoDateInterval(date1: dateStart, date2: dateFinal)
	}
	
	func getSunEvents() -> [SunEvent] {
		var sunEvents : [SunEvent] = []
		
		guard let solar = Solar(for: self.dateStart,coordinate: self.locationStart) else { return [] }
		
			sunEvents.append(.init(
				type: solar.isDaytime ? .day : .night,
				location: self.locationStart,
				timeStart: self.dateStart,
				timeFinal: nil
			))
		
		let dates = DateParcer.getDaysIncludedInRange(startDateUnnormalised: self.dateStart, endDateUnnormalised: self.dateFinal)
		for date in dates {
			guard let solar = Solar(for: date,coordinate: self.locationStart) else { return [] }
			
			if let sunriseStart = solar.sunrise {
				guard let correctadLocation = self.getLocationByDate(date: sunriseStart) else { return [] }
				guard let correctedSolar = Solar(for: date,coordinate: correctadLocation) else { return [] }
				if let correctedSunriseStart = correctedSolar.civilSunrise, let correctedSunriseEnd = correctedSolar.sunrise {
					if self.dateStart < correctedSunriseStart && correctedSunriseEnd < self.dateFinal {
						sunEvents.append(.init(
							type: .sunrise,
							location: self.locationStart,
							timeStart: correctedSunriseStart,
							timeFinal: correctedSunriseEnd
						))
					}
				}
			}
			if let sunsetEnd = solar.sunset {
				guard let correctadLocation = self.getLocationByDate(date: sunsetEnd) else { return [] }
				guard let correctedSolar = Solar(for: date,coordinate: correctadLocation) else { return [] }
				if let correctedSunsetStart = correctedSolar.sunset, let correctedSunsetEnd = correctedSolar.civilSunset {
					if self.dateStart < correctedSunsetStart && correctedSunsetEnd < self.dateFinal {
						sunEvents.append(.init(
							type: .sunset,
							location: self.locationStart,
							timeStart: correctedSunsetStart,
							timeFinal: correctedSunsetEnd
						))
					}
				}
			}
			
		}
		return sunEvents
	}
	
	private func getLocationByDate(date: Date) -> CLLocationCoordinate2D? {
		if (self.duration != nil) && (self.duration != 0) {
			let avgSpeedLat = abs(self.locationStart.latitude - self.locationFinal.latitude) / self.duration!
			let avgSpeedLong = abs(self.locationStart.longitude - self.locationFinal.longitude) / self.duration!
			
			if let currentDuration = DateParcer.getTwoDateInterval(date1: dateStart, date2: date) {
				return CLLocationCoordinate2D(
					latitude: avgSpeedLat * currentDuration + self.locationStart.latitude,
					longitude: avgSpeedLong * currentDuration + self.locationStart.longitude)
			}
		}
		return nil
	}
}