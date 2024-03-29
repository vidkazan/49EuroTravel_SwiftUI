//
//  Settings.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 25.10.23.
//

import Foundation

extension JourneySettings {
	static func transferDurationCases(count : Int16?) -> JourneySettings.TransferDurationCases {
			switch count {
			case 5:
				return .five
			case 7:
				return .seven
			case 10:
				return .ten
			case 15:
				return .fifteen
			case 30:
				return .thirty
			case 45:
				return .fourtyfive
			case 60:
				return .sixty
			case 120:
				return .hundredtwenty
			default:
				return .zero
			}
	}
	
	enum TransferDurationCases : Int, Hashable, CaseIterable, Codable {
		case zero = 0
		case five = 5
		case seven = 7
		case ten = 10
		case fifteen = 15
		case twenty = 20
		case thirty = 30
		case fourtyfive = 45
		case sixty = 60
		case ninety = 90
		case hundredtwenty = 120
		
		var defaultValue : Self {
			.zero
		}
	}
	
	enum TransferCountCases : String, Hashable, CaseIterable,Codable {
		case unlimited = "Unlimited"
		case one = "1"
		case two = "2"
		case three = "3"
		case four = "4"
		case five = "5"
		
		var queryValue : Int? {
			switch self {
			case .unlimited:
				return nil
			case .one:
				return 1
			case .two:
				return 2
			case .three:
				return 3
			case .four:
				return 4
			case .five:
				return 5
			}
		}
		
		var defaultValue : Self {
			.unlimited
		}
	}
	enum TransportMode : String, Hashable, Codable {
		case regional
		case all
		case custom
		
		var defaultValue : Self {
			.all
		}
	}
	
	enum TransferTime : Hashable,Codable {
		case direct
		case time(minutes : TransferDurationCases)
		
		var defaultValue : Self {
			.time(minutes: .zero)
		}
	}
	enum Accessiblity: String, Hashable,Codable, CaseIterable {
		case partial
		case complete
		
		var defaultValue : Self {
			.partial
		}
	}
	enum WalkingSpeed : String, Hashable, Codable, CaseIterable{
		case fast
		case moderate
		case slow
		
		var defaultValue : Self {
			.fast
		}
	}
}
