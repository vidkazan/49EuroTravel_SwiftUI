//
//  DTO.swift
//  49EuroTravel
//
//  Created by Dmitrii Grigorev on 05.05.23.
//

import Foundation
import SwiftUI

// /journeys

enum StopOverType : String,Equatable, CaseIterable {
	case origin
	case stopover
	case destination
	case footTop
	case footMiddle
	case footBottom
	case transfer
	
	func platform(stopOver : StopViewData) -> Prognosed<String?>? {
		switch self {
		case .stopover:
			return stopOver.departurePlatform.actual == nil ? stopOver.arrivalPlatform : stopOver.departurePlatform
		case .destination,.footBottom:
			return stopOver.arrivalPlatform
		case .footTop,.origin,.footMiddle,.transfer:
			return stopOver.departurePlatform
		}
	}
	
	func timeLabelViewTime(timeStringContainer : TimeContainer.TimeStringContainer) -> Prognosed<String?> {
		switch self {
		case .destination, .footBottom:
			return timeStringContainer.arrival
		case .stopover:
			return timeStringContainer.departure.actual == nil ? timeStringContainer.arrival : timeStringContainer.departure
		default:
			return timeStringContainer.departure
		}
	}
	
	func timeLabelViewDelay(timeContainer : TimeContainer) -> Int? {
		switch self {
		case .destination, .footBottom:
			return timeContainer.arrivalStatus.value
		default:
			return timeContainer.departureStatus.value
		}
	}
	
	var showBadgesOnLegStopView : Bool {
		switch self {
		case .origin:
			return true
		default:
			return false
		}
	}
	
	var timeLabelCornerRadius : CGFloat {
		switch self {
		case .stopover:
			return 5
		default:
			return 7
		}
	}
	
	var timeLabelArragament : TimeLabelView.Arragement {
		switch self {
		case .origin:
			return .bottom
		case .stopover:
			return .right
		case .destination:
			return .bottom
		case .footTop:
			return .bottom
		case .footMiddle:
			return .right
		case .footBottom:
			return .bottom
		case .transfer:
			return .right
		}
	}
	
	var smallTimeLabel : Bool {
		switch self {
		case .stopover:
			return true
		default:
			return false
		}
	}
	
	var timeLabelHeight : Double {
		switch self {
		case .destination,.origin,.footBottom,.footTop:
			return 25
		case .transfer,.footMiddle,.stopover:
			return 15
		}
	}
	
	var viewHeight : Double {
		switch self {
		case .destination:
			return 50
		case .origin:
			return 110
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

struct LegDTO : Codable,Equatable, Identifiable {
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
	let tripIdAlternative : String?
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
		case tripId = "tripId"
		case tripIdAlternative = "id"
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
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.origin = try container.decodeIfPresent(StopDTO.self, forKey: .origin)
		self.destination = try container.decodeIfPresent(StopDTO.self, forKey: .destination)
		self.line = try container.decodeIfPresent(Line.self, forKey: .line)
		self.remarks = try container.decodeIfPresent([Remark].self, forKey: .remarks)
		self.departure = try container.decodeIfPresent(String.self, forKey: .departure)
		self.plannedDeparture = try container.decodeIfPresent(String.self, forKey: .plannedDeparture)
		self.arrival = try container.decodeIfPresent(String.self, forKey: .arrival)
		self.plannedArrival = try container.decodeIfPresent(String.self, forKey: .plannedArrival)
		self.departureDelay = try container.decodeIfPresent(Int.self, forKey: .departureDelay)
		self.arrivalDelay = try container.decodeIfPresent(Int.self, forKey: .arrivalDelay)
		self.reachable = try container.decodeIfPresent(Bool.self, forKey: .reachable)
		self.tripIdAlternative = try container.decodeIfPresent(String.self, forKey: .tripIdAlternative)
		if self.tripIdAlternative == nil {
			self.tripId = try container.decodeIfPresent(String.self, forKey: .tripId)
		} else {
			self.tripId = self.tripIdAlternative
		}
		self.direction = try container.decodeIfPresent(String.self, forKey: .direction)
		self.currentLocation = try container.decodeIfPresent(LocationCoordinatesDTO.self, forKey: .currentLocation)
		self.arrivalPlatform = try container.decodeIfPresent(String.self, forKey: .arrivalPlatform)
		self.plannedArrivalPlatform = try container.decodeIfPresent(String.self, forKey: .plannedArrivalPlatform)
		self.departurePlatform = try container.decodeIfPresent(String.self, forKey: .departurePlatform)
		self.plannedDeparturePlatform = try container.decodeIfPresent(String.self, forKey: .plannedDeparturePlatform)
		self.walking = try container.decodeIfPresent(Bool.self, forKey: .walking)
		self.stopovers = try container.decodeIfPresent([StopWithTimeDTO].self, forKey: .stopovers)
		self.distance = try container.decodeIfPresent(Int.self, forKey: .distance)
		self.polyline = try container.decodeIfPresent(PolylineDTO.self, forKey: .polyline)
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
