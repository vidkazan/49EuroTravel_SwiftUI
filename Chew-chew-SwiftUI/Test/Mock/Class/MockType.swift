//
//  MockTypes.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 30.11.23.
//

import Foundation

enum MockType {
	case locations
	case journeyList
	case journey
	case trip
	case generic(String)
	
	var directoryPath : String {
		switch self {
		case .locations:
			return "MockFiles/Locations/"
		case .journeyList:
			return "MockFiles/JourneyList/"
		case .journey:
			return "MockFiles/Journey/"
		case .trip:
			return "MockFiles/Trip/"
		case .generic(let path):
			return path
		}
	}
}
