//
//  Settings.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 25.10.23.
//

import Foundation

struct ChewSettings : Equatable,Hashable {
	let onboarding : Bool
	let customTransferModes : Set<LineType>
	let transportMode : TransportMode
	let transferTime : TransferTime
	let transferCount : TransferCountCases
	let accessiblity : Accessiblity
	let walkingSpeed : WalkingSpeed
	let language : Language
	let debugSettings : ChewDebugSettings
	let startWithWalking : Bool
	let withBicycle : Bool
}

extension ChewSettings {
	static func transferDurationCases(count : Int16?) -> ChewSettings.TransferDurationCases {
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
	enum TransferDurationCases : Int, Equatable, Hashable, CaseIterable {
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
	}
	
	enum TransferCountCases : String, Equatable, Hashable, CaseIterable {
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
	}
	enum TransportMode : Int, Equatable, Hashable {
		case regional = 1
		case all = 0
		case custom = 2
	}
	
	// TODO: test: transfer time -Xmin -> Xmin
	enum TransferTime : Equatable, Hashable {
		case direct
		case time(minutes : TransferDurationCases)
	}
	enum Accessiblity: Equatable, Hashable {
		case partial
		case complete
	}
	enum WalkingSpeed : Equatable, Hashable{
		case fast
		case moderate
		case slow
	}
	enum Language : Equatable, Hashable {
		case english
		case german
	}
	struct ChewDebugSettings: Equatable, Hashable {
		let prettyJSON : Bool
		let alternativeSearchPage : Bool
	}
}

extension ChewSettings {
	init() {
		self.customTransferModes = []
		self.accessiblity = .partial
		self.debugSettings = Self.ChewDebugSettings(prettyJSON: false, alternativeSearchPage: false)
		self.language = .english
		self.startWithWalking = true
		self.transferTime = .time(minutes: .zero)
		self.transportMode = .all
		self.walkingSpeed = .fast
		self.withBicycle = false
		self.onboarding = true
		self.transferCount = .unlimited
	}
	init(settings : ChewSettings, onboarding : Bool) {
		self.customTransferModes = settings.customTransferModes
		self.accessiblity = settings.accessiblity
		self.debugSettings = settings.debugSettings
		self.language = settings.language
		self.startWithWalking = settings.startWithWalking
		self.transferTime = settings.transferTime
		self.transportMode = settings.transportMode
		self.walkingSpeed = settings.walkingSpeed
		self.withBicycle = settings.withBicycle
		self.onboarding = onboarding
		self.transferCount = settings.transferCount
	}
}
