//
//  Query.swift
//  49EuroTravel
//
//  Created by Dmitrii Grigorev on 05.05.23.
//

import Foundation

//Query Parameters
//	parameter	description	type	default value
//	when	Date & time to get departures for. See date/time parameters.	date+time	now
//direction	Filter departures by direction.	string
//duration	Show departures for how many minutes?	integer	10
//results	Max. number of departures.	integer	whatever HAFAS wants
//linesOfStops	Parse & return lines of each stop/station?	boolean	false
//remarks	Parse & return hints & warnings?	boolean	true
//language	Language of the results.	string	en
//nationalExpress	Include InterCityExpress (ICE)?	boolean	true
//national	Include InterCity & EuroCity (IC/EC)?	boolean	true
//regionalExpress	Include RegionalExpress & InterRegio (RE/IR)?	boolean	true
//regional	Include Regio (RB)?	boolean	true
//suburban	Include S-Bahn (S)?	boolean	true
//bus	Include Bus (B)?	boolean	true
//ferry	Include Ferry (F)?	boolean	true
//subway	Include U-Bahn (U)?	boolean	true
//tram	Include Tram (T)?	boolean	true
//taxi	Include Group Taxi (Taxi)?	boolean	true
//pretty	Pretty-print JSON responses?	boolean	true


enum Query{
	case transferTime(transferTime: String)
	case location(location : String?)
	case when(time : Date?)
	case direction(dir : String)
	case duration(minutes : Int)
	case results(max: Int)
	case linesOfStops(showStopLines : Bool)
	case remarks(showRemarks: Bool)
	case language(language : String)
	case nationalExpress(iceTrains: Bool)
	case national(icTrains: Bool)
	case regionalExpress(reTrains: Bool)
	case regional(rbTrains: Bool)
	case suburban(sBahn: Bool)
	case bus(bus: Bool)
	case ferry(ferry: Bool)
	case subway(uBahn: Bool)
	case tram(tram: Bool)
	case taxi(taxi : Bool)
	case pretty(pretyIntend: Bool)
	case departureStop(departureStopId : String?)
	case arrivalStop(arrivalStopId : String?)
	case departureTime(departureTime : Date)
	case arrivalTime(arrivalTime : Date)
	case earlierThan(earlierRef : String)
	case laterThan(laterRef : String)
	case showAddresses(showAddresses : Bool)
	case showPointsOfInterests(showPointsOfInterests : Bool)
	
	func getQueryMethod() -> URLQueryItem {
		switch self {
		case .location(let location):
			return URLQueryItem(
				name: "query",
				value: location)
		case .when(let time):
			var res = Date.now
			if let time = time {
				res = time
			}
			return URLQueryItem(name: "when", value: String(res.timeIntervalSince1970))
		case .direction(let dir):
			return URLQueryItem(
				name: "direction",
				value: dir)
		case .duration(let minutes):
			return URLQueryItem(
				name: "duration",
				value: String(minutes))
		case .results(let max):
			return URLQueryItem(
				name: "results",
				value: String(max))
		case .linesOfStops(let showStopLines):
			return URLQueryItem(
				name: "linesOfStops",
				value: String(showStopLines))
		case .remarks(let showRemarks):
			return URLQueryItem(
				name: "remarks",
				value: String(showRemarks))
		case .language(let language):
			return URLQueryItem(
				name: "language",
				value: language)
		case .nationalExpress(let iceTrains):
			return URLQueryItem(
				name: "nationalExpress",
				value: String(iceTrains))
		case .national(let icTrains):
			return URLQueryItem(
				name: "national",
				value: String(icTrains))
		case .regionalExpress(let reTrains):
			return URLQueryItem(
				name: "regionalExpress",
				value: String(reTrains))
		case .regional(let rbTrains):
			return URLQueryItem(
				name: "regional",
				value: String(rbTrains))
		case .suburban(let sBahn):
			return URLQueryItem(
				name: "suburban",
				value: String(sBahn))
		case .bus(let bus):
			return URLQueryItem(
				name: "bus",
				value: String(bus))
		case .ferry(let ferry):
			return URLQueryItem(
				name: "ferry",
				value: String(ferry))
		case .subway(let uBahn):
			return URLQueryItem(
				name: "subway",
				value: String(uBahn))
		case .tram(let tram):
			return URLQueryItem(
				name: "tram",
				value: String(tram))
		case .taxi(let taxi):
			return URLQueryItem(
				name: "taxi",
				value: String(taxi))
		case .pretty(let prettyIntend):
			return URLQueryItem(
				name: "pretty",
				value: String(prettyIntend))
		case .departureStop(let departureStopId):
			return URLQueryItem(
				name: "from",
				value: departureStopId)
		case .arrivalStop(let arrivalStopId):
			return URLQueryItem(
				name: "to",
				value: arrivalStopId)
		case .departureTime(let departureTime):
			return URLQueryItem(
				name: "departure",
				value: ISO8601DateFormatter().string(from: departureTime))
		case .arrivalTime(let arrivalTime):
			return URLQueryItem(
				name: "arrival",
				value: ISO8601DateFormatter().string(from: arrivalTime))
		case .transferTime(let transferTime):
			return URLQueryItem(
				name: "transferTime",
				value: transferTime)
		case .earlierThan(earlierRef: let earlierRef):
			return URLQueryItem(
				name: "earlierThan",
				value: earlierRef)
		case .laterThan(laterRef: let laterRef):
			return URLQueryItem(
				name: "laterThan",
				value: laterRef)
		case .showAddresses(showAddresses: let showAddresses):
			return URLQueryItem(
				name: "addresses",
				value: String(showAddresses))
		case .showPointsOfInterests(showPointsOfInterests: let showPointsOfInterests):
			return URLQueryItem(
				name: "poi",
				value: String(showPointsOfInterests))
		}
	}
	static func getQueryItems(methods : [Query]) -> [URLQueryItem] {
		return methods.map { $0.getQueryMethod() }
	}
}

enum QueryRange{
	case beginAt(dateFrom: Date,dateTo: Date)
	case login(login : String)
	
	var queryPrefix : String {
		switch self {
		case .beginAt:
			return "range[begin_at]"
		case .login:
			return "range[login]"
		}
	}
	func getRange() -> URLQueryItem {
		switch self {
		case .beginAt(let date1, let date2):
			let value = "\(DateParcer.getStringFromDate(date: date1) ?? ""),\(DateParcer.getStringFromDate(date: date2) ?? "")"
			return URLQueryItem(name: self.queryPrefix, value: value)
		case .login(let login):
			let value = "\(login.lowercased()),\(login.lowercased())z"
			return URLQueryItem(name: self.queryPrefix, value: value)
		}
	}
}
