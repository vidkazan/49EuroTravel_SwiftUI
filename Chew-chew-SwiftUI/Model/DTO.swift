//
//  DTO.swift
//  49EuroTravel
//
//  Created by Dmitrii Grigorev on 05.05.23.
//

import Foundation

// /journeys

struct StopOver : Codable,Equatable,Identifiable {
	let id = UUID()
	let stop				: StopDTO?
	let departure,
		plannedDeparture	: String?
	let arrival,
		plannedArrival		: String?
	let departureDelay,
		arrivalDelay		: Int?
	let reachable			: Bool?
	let arrivalPlatform,
		plannedArrivalPlatform		: String?
	let departurePlatform,
		plannedDeparturePlatform	: String?
	let remarks						: [Remark]?
	let cancelled : 			Bool?
	
	
	private enum CodingKeys : String, CodingKey {
		case cancelled
		case stop
		case departure
		case plannedDeparture
		case arrival
		case plannedArrival
		case departureDelay
		case arrivalDelay
		case reachable
		case arrivalPlatform
		case plannedArrivalPlatform
		case departurePlatform
		case plannedDeparturePlatform
		case remarks
	}
}

struct Leg : Codable,Equatable,Identifiable{
	let id = UUID()
	let origin : StopDTO?
	let destination : StopDTO?
	let line : Line?
	let remarks : [Remark]?
	let departure: String?
	let plannedDeparture: String?
	let arrival: String?
	let plannedArrival: String?
	let departureDelay,
		arrivalDelay: Int?
	let reachable: Bool?
	let tripId : String?
	let direction: String?
	let currentLocation: LocationCoordinates?
	let arrivalPlatform,
		plannedArrivalPlatform: String?
	let departurePlatform,
		plannedDeparturePlatform : String?
	let walking : Bool?
	let distance : Int?
	let stopovers : [StopOver]?
	
	private enum CodingKeys : String, CodingKey {
		case origin
		case destination
		case line
		case remarks
		case departure
		case plannedDeparture
		case arrival
		case plannedArrival
		case departureDelay
		case arrivalDelay
		case reachable
		case tripId
		case direction
		case currentLocation
		case arrivalPlatform
		case plannedArrivalPlatform
		case departurePlatform
		case plannedDeparturePlatform
		case walking
		case stopovers
		case distance
	}
}

struct Price : Codable,Equatable {
	let amount		: Double?
	let currency	: String?
	let hint		: String?
}

struct JourneyWrapper : Codable,Equatable {
	let journey : Journey
}
struct Journey : Codable,Identifiable,Equatable {
	let id = UUID()
	let type : String?
	let legs : [Leg]
	let refreshToken : String?
	let remarks : [Remark]?
	let price : Price?
	private enum CodingKeys : String, CodingKey {
		case type
		case legs
		case refreshToken
		case remarks
		case price
	}
}

struct JourneysContainer : Codable,Equatable {
	let earlierRef: String?
	let laterRef: String?
	let journeys : [Journey]?
	let realtimeDataUpdatedAt: Int64?
}

enum LocationType : Equatable {
	case pointOfInterest
	case location
	case stop

}

struct StopDTO : Codable, Identifiable, Equatable,Hashable {
	let type	: String?
	let id		: String?
	let name	: String?
	let address		: String?
	let location	: LocationCoordinates?
	let latitude	: Double?
	let longitude	: Double?
	let poi			: Bool?
	let products	: Products?
	
	private enum CodingKeys : String, CodingKey {
		case type
		case id
		case name
		case address
		case location
		case products
		case latitude
		case longitude
		case poi
	}
}


// /departures

struct Departure : Codable,Equatable {
	let tripId				: String?
	let stop				: StopDTO?
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
	let destination			: StopDTO?
	let cancelled			: Bool?
}


// MARK: - Location
struct LocationCoordinates : Codable,Equatable,Hashable {
	let type		: String?
	let id			: String?
	let latitude	: Double?
	let longitude	: Double?
}

// MARK: - Products
struct Products : Codable, Equatable,Hashable {
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
