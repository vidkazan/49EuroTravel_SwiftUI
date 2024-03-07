//
//  Settings.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 25.10.23.
//

import Foundation

struct Settings : Equatable,Hashable {
	// api settings
	let customTransferModes : Set<LineType>
	let transportMode : TransportMode
	let transferTime : TransferTime
	let transferCount : TransferCountCases
	let accessiblity : Accessiblity
	let walkingSpeed : WalkingSpeed
	let language : Language
	let startWithWalking : Bool
	let withBicycle : Bool
	// app settings
	let onboarding : Bool
	let debugSettings : ChewDebugSettings
	let legViewMode : LegViewMode
}

extension Settings {
	func isDefault() -> Bool {
		guard transportMode == transportMode.defaultValue else {
			return false
		}
		guard transferTime == transferTime.defaultValue else {
			return false
		}
		guard transferCount == transferCount.defaultValue else {
			return false
		}
		guard accessiblity == accessiblity.defaultValue else {
			return false
		}
		guard startWithWalking == true else {
			return false
		}
		guard withBicycle == false else {
			return false
		}
		return true
	}
}
