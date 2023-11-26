//
//  Query.swift
//  49EuroTravel
//
//  Created by Dmitrii Grigorev on 05.05.23.
//

import Foundation

enum Query{
	case transferTime(transferTime: Int)
	case location(location : String?)
	case when(time : Date?)
	case direction(dir : String)
	case duration(minutes : Int)
	case results(max: Int)
	case linesOfStops(showStopLines : Bool)
	case remarks(showRemarks: Bool)
	case language(language : String)
	case pretty(pretyIntend: Bool)
	case polylines(_ isShowing : Bool)
	case transfersCount(_ count : Int)
	
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
	
	case departureStopId(departureStopId : String)
	case departureLatitude(departureLatitude : String)
	case departureLongitude(departureLongitude : String)
	case departureAddress(addr: String)
	case departurePoiId(poiId: String)
	case departurePoiName(poiName: String)
	
	case arrivalStopId(arrivalStopId : String)
	case arrivalLatitude(arrivalLatitude : String)
	case arrivalLongitude(arrivalLongitude : String)
	case arrivalAddress(addr: String)
	case arrivalPoiId(poiId: String)
	case arrivalPoiName(poiName: String)
	
	case departureTime(departureTime : Date)
	case arrivalTime(arrivalTime : Date)
	case earlierThan(earlierRef : String)
	case laterThan(laterRef : String)
	
	case showAddresses(showAddresses : Bool)
	case showPointsOfInterests(showPointsOfInterests : Bool)
	case stopovers(isShowing: Bool)
	
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
		case .departureStopId(let departureStopId):
			return URLQueryItem(
				name: "from",
				value: departureStopId)
		case .arrivalStopId(let arrivalStopId):
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
				value: String(transferTime))
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
		case .departureLatitude(departureLatitude: let departureLatitude):
			return URLQueryItem(
				name: "from.latitude",
				value: String(departureLatitude))
		case .departureLongitude(departureLongitude: let departureLongitude):
			return URLQueryItem(
				name: "from.longitude",
				value: String(departureLongitude))
		case .arrivalLatitude(arrivalLatitude: let arrivalLatitude):
			return URLQueryItem(
				name: "to.latitude",
				value: String(arrivalLatitude))
		case .arrivalLongitude(arrivalLongitude: let arrivalLongitude):
			return URLQueryItem(
				name: "to.longitude",
				value: String(arrivalLongitude))
		case .departureAddress(addr: let addr):
			return URLQueryItem(
				name: "from.address",
				value: String(addr))
		case .arrivalAddress(addr: let addr):
			return URLQueryItem(
				name: "to.address",
				value: String(addr))
		case .departurePoiId(poiId: let poiId):
			return URLQueryItem(
				name: "from.id",
				value: String(poiId))
		case .arrivalPoiId(poiId: let poiId):
			return URLQueryItem(
				name: "to.id",
				value: String(poiId))
		case .stopovers(isShowing: let isShowing):
			return URLQueryItem(
				name: "stopovers",
				value: String(isShowing))
		case .polylines(let show):
			return URLQueryItem(
				name: "polylines",
				value: String(show))
		case .transfersCount(let count):
			return URLQueryItem(
				name: "transfers",
				value: String(count))
		case .departurePoiName(poiName: let poiName):
			return URLQueryItem(
				name: "from.name",
				value: poiName)
		case .arrivalPoiName(poiName: let poiName):
			return URLQueryItem(
				name: "to.name",
				value: poiName)
		}
	}
	static func getQueryItems(methods : [Query]) -> [URLQueryItem] {
		return methods.map {
			$0.getQueryMethod()
		}
	}
}
