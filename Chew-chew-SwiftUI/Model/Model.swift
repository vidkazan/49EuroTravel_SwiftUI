//
//  Model.swift
//  49EuroTravel
//
//  Created by Dmitrii Grigorev on 05.05.23.
//

import Foundation

// /journeys

struct Leg : Decodable {
//	let origin : Stop?
//	let destination : Stop?
	let line : Line?
//	let remarks : [Remark]?
	let departure: String?
	let plannedDeparture: String?
	let arrival: String?
	let plannedArrival: String?
	let departureDelay,arrivalDelay: Int?
//	let reachable: Bool?
//	let tripId, direction: String?
////	let currentLocation: CurrentLocation
//	let arrivalPlatform, plannedArrivalPlatform: String?
//	let arrivalPrognosisType: String?
//	let departurePlatform, plannedDeparturePlatform, departurePrognosisType: String?
}

struct Journey : Decodable {
	let type : String?
	let legs : [Leg]?
//	let refreshToken : String?
//	let remarks : [Remark]?
//	let price : String?
}

struct JourneysContainer : Decodable {
	let earlierRef: String?
	let laterRef: String?
	let journeys : [Journey]?
//	let realtimeDataUpdatedAt: Int64?
}

// /locations
struct Stops : Decodable {
	let stops : [Stop]
}

struct Stop : Decodable, Identifiable, Equatable {
	let type	: String?
	let id		: String?
	let name	: String?
	let location : Location?
	let products : Products?
}


// /departures
struct Departures : Decodable {
	let departures : [Departure]
}

struct Departure : Decodable {
	let tripId				: String?
	let stop				: Destination
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
	let line				: Line
	let remarks				: [Remark]
	let origin				: String?
	let destination			: Destination
	let cancelled			: Bool?
}

// MARK: - Destination
class Destination : Decodable {
	let type		: String?
	let id			: String?
	let name		: String?
	let location	: Location
	let products	: Products
}

// MARK: - Location
struct Location : Decodable,Equatable {
	let type		: String?
	let id			: String?
	let latitude	: Double?
	let longitude	: Double?
}

// MARK: - Products
struct Products : Decodable, Equatable {
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
struct Line : Decodable {
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
struct Remark : Decodable {
	let type	: String?
	let code	: String?
	let text	: String?
}

struct Station : Decodable {
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
