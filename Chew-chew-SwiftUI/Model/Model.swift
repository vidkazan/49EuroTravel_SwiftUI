//
//  Model.swift
//  49EuroTravel
//
//  Created by Dmitrii Grigorev on 05.05.23.
//

import Foundation

// /journeys

struct Leg : Codable {
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
//	enum CodingKeys: String, CodingKey {
//		case line = "line"
//		case departure = "departure"
//		case plannedDeparture = "plannedDeparture"
//		case arrival = "arrival"
// 		case plannedArrival = "plannedArrival"
//		case departureDelay = "departureDelay"
//		case arrivalDelay = "arrivalDelay"
//	 }
}

struct Journey : Codable,Identifiable {
	let id = UUID()
	let type : String?
	let legs : [Leg]?
//	let refreshToken : String?
//	let remarks : [Remark]?
//	let price : String?
	private enum CodingKeys : String, CodingKey {
		case type
		case legs
//		case refreshToken
//		case remarks
//		case price
	}
}

struct JourneysContainer : Codable {
	let earlierRef: String?
	let laterRef: String?
	let journeys : [Journey]?
//	let realtimeDataUpdatedAt: Int64?
}

// /locations
struct Stops : Codable {
	let stops : [Stop]
}

struct Stop : Codable, Identifiable, Equatable {
	let type	: String?
	let id		: String?
	let name	: String?
	let location : Location?
	let products : Products?
}


// /departures
struct Departures : Codable {
	let departures : [Departure]
}

struct Departure : Codable {
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
class Destination : Codable {
	let type		: String?
	let id			: String?
	let name		: String?
	let location	: Location
	let products	: Products
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
struct Line : Codable {
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
struct Remark : Codable {
	let type	: String?
	let code	: String?
	let text	: String?
}

struct Station : Codable {
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
