//
//  ApiServiceErrors.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 22.01.24.
//

import Foundation

enum JourneyDetailsError : ChewError {
	static func == (lhs: JourneyDetailsError, rhs: JourneyDetailsError) -> Bool {
		return lhs.description == rhs.description
	}
	
	func hash(into hasher: inout Hasher) {
		switch self {
		case .tripIdIsNil:
			break
		}
	}
	case tripIdIsNil
	
	
	var description : String  {
		switch self {
		case .tripIdIsNil:
			return "TripID is nil"
		}
	}
}

enum ConstructLegDataError : ChewError {
	static func == (lhs: ConstructLegDataError, rhs: ConstructLegDataError) -> Bool {
		return lhs.description == rhs.description
	}
	
	func hash(into hasher: inout Hasher) {
		switch self {
		case .departureOrArrivalPosition:
			break
		}
	}
	case departureOrArrivalPosition
	
	
	var description : String  {
		switch self {
		case .departureOrArrivalPosition:
			return "plannedDeparturePosition or plannedArrivalPosition is NIL"
		}
	}
}
