//
//  DataSourse.swift
//  49EuroTravel
//
//  Created by Dmitrii Grigorev on 09.08.23.
//

import Foundation

enum LocationDirectionType{
	case departure
	case arrival
	
	var placeholder : String {
		switch self {
		case .departure:
			return "from"
		case .arrival:
			return "to"
		}
	}
}

struct SearchLocationData {
	let type : LocationDirectionType
	let stop : Stop
	
	init(type: LocationDirectionType, stop : Stop) {
		self.type = type
		self.stop = stop
	}
}

struct JourneySearchData {
	var departureStop : SearchLocationData?
	var arrivalStop : SearchLocationData?
	var departureTime : Date = Date.now
	var arrivalTime : Date = Date.now
	
	mutating func updateSearchStopData(type: LocationDirectionType, stop : Stop) -> Bool {
		switch type {
		case .departure:
			self.departureStop =  SearchLocationData(type: .departure, stop: stop)
		case .arrival:
			self.arrivalStop =  SearchLocationData(type: .arrival, stop : stop)
		}
		if self.arrivalStop != nil && self.departureStop != nil {
			return true
		}
		return false
	}
	
	mutating func updateSearchTimeData(departureTime : Date?) -> Bool {
		guard let departureTime = departureTime else { return false }
		self.departureTime = departureTime
		if self.arrivalStop != nil && self.departureStop != nil {
			return true
		}
		return false
	}
}
