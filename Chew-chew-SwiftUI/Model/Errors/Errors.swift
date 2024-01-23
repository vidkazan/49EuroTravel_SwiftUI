//
//  ApiServiceErrors.swift.swift
//  49EuroTravel
//
//  Created by Dmitrii Grigorev on 05.05.23.
//

import Foundation

struct CustomErrors : Error {
	let apiServiceErrors : any ChewError
	let source : ApiService.Requests
}

protocol ChewError : Error, Equatable, Hashable {
	var description : String { get }
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