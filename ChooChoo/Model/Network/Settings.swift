//
//  Settings.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 25.10.23.
//

import Foundation

struct ChewSettings : Equatable,Hashable {
	enum TransportMode : Int, Equatable, Hashable {
		case regional
		case all
		case custom
		
		var id : Int {
			switch self {
			case .all:
				return 0
			case .regional:
				return 1
			case .custom:
				return 2
			}
		}
	}
	
	// TODO: test: transfer time -Xmin -> Xmin
	enum TransferTime : Equatable, Hashable {
		case direct
		case time(minutes : Int)
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
	enum Language : Equatable, Hashable{
		case english
		case deutsch
	}
	struct ChewDebugSettings: Equatable, Hashable {
		let prettyJSON : Bool
		let alternativeSearchPage : Bool
	}
	let onboarding : Bool
	let customTransferModes : Set<LineType>
	let transportMode : TransportMode
	let transferTime : TransferTime
	let accessiblity : Accessiblity
	let walkingSpeed : WalkingSpeed
	let language : Language
	let debugSettings : ChewDebugSettings
	let startWithWalking : Bool
	let withBicycle : Bool
}

extension ChewSettings {
	init() {
		self.customTransferModes = []
		self.accessiblity = .partial
		self.debugSettings = Self.ChewDebugSettings(prettyJSON: false, alternativeSearchPage: false)
		self.language = .english
		self.startWithWalking = true
		self.transferTime = .time(minutes: 0)
		self.transportMode = .regional
		self.walkingSpeed = .fast
		self.withBicycle = false
		self.onboarding = true
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
	}
}
