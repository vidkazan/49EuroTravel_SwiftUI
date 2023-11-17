//
//  DateParcer.swift
//  49EuroTravel
//
//  Created by Dmitrii Grigorev on 05.05.23.
//

import Foundation

class DateParcer {
	static private let formatDateAndTime = "yyyyMMdd'T'HHmmssZ"
	
	static private let dateFormatter : DateFormatter = {
		let f = DateFormatter()
		f.dateFormat = formatDateAndTime
		return f
	}()
	
	static private let ISOdateFormatter : ISO8601DateFormatter = {
		let f = ISO8601DateFormatter()
		return f
	}()
	
	static private func parseDate(from dateString : String?) -> Date? {
		guard let dateString = dateString else { return nil }
		if let date = dateFormatter.date(from: dateString) { return date }
		guard let date = ISOdateFormatter.date(from: dateString) else { return nil }
		return date
	}
	
	static func getTwoDateIntervalInMinutes(date1String : String?,date2String : String?) -> Int? {
		guard let date1 = parseDate(from: date1String),
			  let date2 = parseDate(from: date2String) else { return nil }
		let interval = date2.timeIntervalSinceReferenceDate - date1.timeIntervalSinceReferenceDate
		return Int((interval / 60))
	}
	
	static func getTwoDateIntervalInMinutes(date1 : Date?,date2 : Date?) -> Int? {
		guard let date1 = date1,
			  let date2 = date2 else { return nil }
		let interval = date2.timeIntervalSinceReferenceDate - date1.timeIntervalSinceReferenceDate
		return Int((interval / 60))
	}
	
	static func getTwoDateInterval(date1 : Date?,date2 : Date?) -> Double? {
		guard let date1 = date1,
			  let date2 = date2 else { return nil }
		let interval = date1.timeIntervalSinceReferenceDate - date2.timeIntervalSinceReferenceDate
		return interval
	}
	
	static func getDateFromDateString(dateString : String?) -> Date? {
		return parseDate(from: dateString)
	}
	static func getStringFromDate(date : Date) -> String? {
		return dateFormatter.string(from: date)
	}
	
	static func getDateMinusMonthsAgo(monthsAgo : Int) -> Date? {
		let currentDate = Date()
		let calendar = Calendar.current
		var dateComponents = DateComponents()
		dateComponents.month = -monthsAgo
		let newDate = calendar.date(byAdding: dateComponents, to: currentDate)
		return newDate
	}
	
	static func getTimeStringFromDate(date : Date?) -> String? {
		guard let date = date else { return nil }
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "HH:mm"
		let timeString = dateFormatter.string(from: date)
		return timeString
	}
	
	static func getTimeAndDateStringFromDate(date : Date, withYear : Bool = false) -> String {
		let dateFormatter = DateFormatter()
		switch withYear {
		case true:
			dateFormatter.dateFormat = "dd MMM YYYY HH:mm"
		case false:
			dateFormatter.dateFormat = "dd MMM HH:mm"
		}
		
		let timeString = dateFormatter.string(from: date)
		return timeString
	}
	
	static func getDateOnlyStringFromDate(date : Date?) -> String? {
		guard let date = date else { return nil }
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd MMM YYYY"
		let timeString = dateFormatter.string(from: date)
		return timeString
	}
	
	static func getTimeStringWithHoursAndMinutesFormat(minutes: Int?) -> String? {
		guard let minutes = minutes else { return nil }
		print(minutes)
		if minutes < 0 {
			return "0 min"
		}
		let hours = minutes / 60
		let remainingMinutes = minutes % 60
		
		var formattedTime = ""
		
		if hours > 0 {
			formattedTime = "\(hours)h"
		}
		
		if remainingMinutes > 0 {
			if !formattedTime.isEmpty {
				formattedTime += " "
			}
			formattedTime += "\(remainingMinutes)min"
		}
		return formattedTime
	}
	
	
	static func	getCombinedDate(date: Date, time: Date) -> Date? {
		let timeComponents: DateComponents = Calendar.current.dateComponents([.hour,.minute,.second,.timeZone], from: time)
		let dateComponents: DateComponents = Calendar.current.dateComponents([.year,.month,.day], from: date)
		let combined = DateComponents(calendar: .current, timeZone: timeComponents.timeZone, year: dateComponents.year, month: dateComponents.month, day: dateComponents.day, hour: timeComponents.hour, minute: timeComponents.minute, second: timeComponents.second)
		
		return Calendar.current.date(from: combined)
	}
	
	static func getDaysIncludedInRange(startDateUnnormalised: Date, endDateUnnormalised: Date) -> [Date] {
		guard let startDate = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: startDateUnnormalised),
			  let endDate = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: endDateUnnormalised) else { return [] }
		
		var currentDate = startDate
		var allDays: [Date] = []
		
		let calendar = Calendar.current
		
		while currentDate <= endDate {
			allDays.append(currentDate)
			guard let newCurrDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else { return [] }
			currentDate = newCurrDate
		}
		return allDays
	}
}

