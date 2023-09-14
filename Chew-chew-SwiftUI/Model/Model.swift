//
//  Model.swift
//  49EuroTravel
//
//  Created by Dmitrii Grigorev on 05.05.23.
//

import Foundation

// /journeys

struct Leg : Codable,Equatable{
	let origin : Stop?
	let destination : Stop?
	let line : Line?
	let remarks : [Remark]?
	let departure: String?
	let plannedDeparture: String?
	let arrival: String?
	let plannedArrival: String?
	let departureDelay,arrivalDelay: Int?
	let reachable: Bool?
	//	let tripId, direction: String?
	////	let currentLocation: CurrentLocation
	//	let arrivalPlatform, plannedArrivalPlatform: String?
	//	let arrivalPrognosisType: String?
	let departurePlatform, plannedDeparturePlatform, departurePrognosisType: String?
}

struct Price : Codable,Equatable {
	let amount: Double?
	let currency : String?
	let hint : String?
}
struct Journey : Codable,Identifiable,Equatable {
	let id = UUID()
	let type : String?
	let legs : [Leg]?
//	let refreshToken : String?
	let remarks : [Remark]?
	let price : Price?
	private enum CodingKeys : String, CodingKey {
		case type
		case legs
//		case refreshToken
		case remarks
		case price
	}
}

struct JourneysContainer : Codable,Equatable {
	let earlierRef: String?
	let laterRef: String?
	let journeys : [Journey]?
//	let realtimeDataUpdatedAt: Int64?
}

// /locations
struct Stops : Codable {
	let stops : [Stop]?
}

enum StopType : Equatable {
	case pointOfInterest(Stop)
	case location(Stop)
	case stop(Stop)
	
	var stop : Stop {
		switch self {
		case .pointOfInterest(let stop):
			return stop
		case .location(let stop):
			return stop
		case .stop(let stop):
			return stop
		}
	}
}

struct Stop : Codable, Identifiable, Equatable {
	let type	: String?
	let id		: String?
	let name	: String?
	let address : String?
	let location : Location?
	let products : Products?
	
	private enum CodingKeys : String, CodingKey {
		case type
		case id
		case name
		case address
		case location
		case products
	}
}


// /departures
struct Departures : Codable,Equatable {
	let departures : [Departure]?
}

struct Departure : Codable,Equatable {
	let tripId				: String?
	let stop				: Destination?
	let when				: String?
	let plannedWhen			: String?
	let prognosedWhen		: String?
	let delay				: Int?
	let platform			: String?
	let plannedPlatform		: String?
	let prognosedPlatform	: String?
	let prognosisType		: String?
	let direction			: String?
	let provenance			: String?
	let line				: Line?
	let remarks				: [Remark]?
	let origin				: String?
	let destination			: Destination?
	let cancelled			: Bool?
}

// MARK: - Destination
struct Destination : Codable,Equatable {
	let type		: String?
	let id			: String?
	let name		: String?
	let location	: Location?
	let products	: Products?
}

// MARK: - Location
struct Location : Codable,Equatable {
	let type		: String?
	let id			: String?
	let latitude	: Double?
	let longitude	: Double?
}

// MARK: - Products
struct Products : Codable, Equatable {
	let nationalExpress		: Bool?
	let national			: Bool?
	let regionalExpress		: Bool?
	let regional			: Bool?
	let suburban			: Bool?
	let bus					: Bool?
	let ferry				: Bool?
	let subway				: Bool?
	let tram				: Bool?
	let taxi				: Bool?
}

// MARK: - Line
struct Line : Codable,Equatable {
	let type			: String?
	let id				: String?
	let fahrtNr			: String?
	let name			: String?
	let linePublic		: Bool?
	let adminCode		: String?
	let productName		: String?
	let mode			: String?
	let product			: String?
}

// MARK: - Remark
struct Remark : Codable,Equatable,Hashable {
	let type	: String?
	let code	: String?
	let text	: String?
}

struct Station : Codable,Equatable {
	let EVA_NR			: Int?
	let DS100			: String?
	let IFOPT			: String?
	let NAME			: String?
	let Verkehr			: String?
	let Laenge			: Double?
	let Breite			: Double?
	let Betreiber_Nr	: Int?
	let Status			: String?
}
