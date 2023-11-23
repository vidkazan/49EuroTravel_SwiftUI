//
//  Settings.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 25.10.23.
//

import Foundation

struct ChewSettings : Equatable,Hashable {
//	struct TransportTypeValue : Equatable,Hashable, Identifiable, Comparable {
//		static func < (lhs: TransportTypeValue, rhs: TransportTypeValue) -> Bool {
//			lhs.type.rawValue < rhs.type.rawValue
//		}
//		
//		let id = UUID()
//		let type : LineType
//		let value : Bool
//		
//		init(_ type: LineType,_ value: Bool) {
//			self.type = type
//			self.value = value
//		}
//	}
	enum TransportMode : Int, Equatable, Hashable {
		case deutschlandTicket
		case all
		case custom
		
		var id : Int {
			switch self {
			case .all:
				return 0
			case .deutschlandTicket:
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
	}
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
		self.debugSettings = Self.ChewDebugSettings(prettyJSON: false)
		self.language = .english
		self.startWithWalking = true
		self.transferTime = .time(minutes: 0)
		self.transportMode = .deutschlandTicket
		self.walkingSpeed = .fast
		self.withBicycle = false
	}
}
