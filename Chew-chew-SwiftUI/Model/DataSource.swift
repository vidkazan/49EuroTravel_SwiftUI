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
	private(set) var departureStop : SearchLocationData?
	private(set) var arrivalStop : SearchLocationData?
	private(set) var departureTime : Date = Date.now
	private(set) var arrivalTime : Date = Date.now
	
	mutating func clearStop(type : LocationDirectionType){
		print(">> clear",type.placeholder)
		switch type {
		case .departure:
			self.departureStop = nil
		case .arrival:
			self.arrivalStop = nil
		}
	}
	
	mutating func switchStops() -> Bool {
		swap(&self.departureStop, &self.arrivalStop)
		print(">>",departureStop?.stop.name ?? "nil", arrivalStop?.stop.name ?? "nil")
		if self.arrivalStop != nil && self.departureStop != nil {
			return true
		}
		
		return false
	}
	
	mutating func updateSearchStopData(type: LocationDirectionType, stop : Stop) -> Bool {
		switch type {
		case .departure:
			self.departureStop =  SearchLocationData(type: .departure, stop: stop)
		case .arrival:
			self.arrivalStop =  SearchLocationData(type: .arrival, stop : stop)
		}
		print(">> update",departureStop?.stop.name ?? "nil", arrivalStop?.stop.name ?? "nil")
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
