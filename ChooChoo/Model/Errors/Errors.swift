//
//  ApiServiceErrors.swift.swift
//  49EuroTravel
//
//  Created by Dmitrii Grigorev on 05.05.23.
//

import Foundation

protocol ChewError : Error, Equatable, Hashable {
//	var description : String { get }
	var localizedDescription : String { get }
}

enum DataError : ChewError {
	static func == (lhs: DataError, rhs: DataError) -> Bool {
		return lhs.description == rhs.description
	}
	
	func hash(into hasher: inout Hasher) {
		switch self {
		case .generic,.nilValue,.validationError:
			break
		}
	}
	case validationError(msg: String)
	case nilValue(type : String)
	case generic(msg: String)
	
	var description : String  {
		switch self {
		case .validationError(let msg):
			return "validation error: \(msg)"
		case .nilValue(type: let type):
			return "value is nil: \(type)"
		case .generic(let msg):
			return "error: \(msg)"
		}
	}
}
