//
//  DTO.swift
//  49EuroTravel
//
//  Created by Dmitrii Grigorev on 05.05.23.
//

import Foundation

// /journeys

enum StopOverType : String,Equatable {
	case origin
	case stopover
	case destination
	case footTop
	case footMiddle
	case footBottom
	case transfer
	
	var timeLabelHeight : Double {
		switch self {
		case .destination,.origin,.footBottom,.footTop:
			return 30
		case .transfer,.footMiddle,.stopover:
			return 15
		}
	}
	
	var viewHeight : Double {
		switch self {
		case .destination:
			return 50
		case .origin:
			return 90
		case .stopover:
			return 35
		case .transfer,.footMiddle:
			return 70
		case .footTop:
			return 70
		case .footBottom:
			return 70
		}
	}
}

enum StopOverCancellationType : Equatable {
	case notCancelled
	case exitOnly
	case entryOnly
	case fullyCancelled
	
	static func getCancelledTypeFromDelayStatus(
		arrivalStatus : TimeContainer.DelayStatus ,
		departureStatus: TimeContainer.DelayStatus
	) -> Self {
		if arrivalStatus == .cancelled && departureStatus == .cancelled {
			return .fullyCancelled
		} else if arrivalStatus == .cancelled {
			return .entryOnly
		} else if departureStatus == .cancelled {
			return .exitOnly
		} else {
			return .notCancelled
		}
	}
}

struct StopWithTimeDTO : Codable,Equatable,Identifiable {
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

struct TripDTO : Codable,Equatable,Identifiable {
	let id = UUID()
	let trip : LegDTO
	private enum CodingKeys : String, CodingKey {
		case trip
	}
}

struct LegDTO : Codable,Equatable,Identifiable{
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
	let currentLocation: LocationCoordinatesDTO?
	let arrivalPlatform,
		plannedArrivalPlatform: String?
	let departurePlatform,
		plannedDeparturePlatform : String?
	let walking : Bool?
	let distance : Int?
	let stopovers : [StopWithTimeDTO]?
	let polyline : PolylineDTO?
	
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
		case polyline
	}
}

struct PriceDTO : Codable,Equatable {
	let amount		: Double?
	let currency	: String?
	let hint		: String?
}

struct JourneyWrapper : Codable,Equatable {
	let journey : JourneyDTO
	let realtimeDataUpdatedAt: Int64?
}
struct JourneyDTO : Codable,Identifiable,Equatable {
	let id = UUID()
	let type : String?
	let legs : [LegDTO]
	let refreshToken : String?
	let remarks : [Remark]?
	let price : PriceDTO?
	private enum CodingKeys : String, CodingKey {
		case type
		case legs
		case refreshToken
		case remarks
		case price
	}
}

struct JourneyListDTO : Codable,Equatable {
	let earlierRef: String?
	let laterRef: String?
	let journeys : [JourneyDTO]?
	let realtimeDataUpdatedAt: Int64?
}

enum LocationType : Int16, Equatable, Hashable {
	case pointOfInterest
	case location
	case stop
}

struct StopDTO : Codable, Identifiable, Equatable,Hashable {
	let type	: String?
	let id		: String?
	let name	: String?
	let address		: String?
	let location	: LocationCoordinatesDTO?
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
struct LocationCoordinatesDTO : Codable,Equatable,Hashable {
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
