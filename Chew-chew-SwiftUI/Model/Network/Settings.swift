//
//  Settings.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 25.10.23.
//

import Foundation

struct ChewSettings : Equatable,Hashable {
	enum TransportMode : Equatable, Hashable {
		case deutschlandTicket
		case all
		case custom(types : Products)
	}
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
	}
	
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
		self.accessiblity = .partial
		self.debugSettings = Self.ChewDebugSettings(prettyJSON: false)
		self.language = .english
		self.startWithWalking = true
		self.transferTime = .time(minutes: 0)
		self.transportMode = .deutschlandTicket
		self.walkingSpeed = .fast
		self.withBicycle = false
	}
}
