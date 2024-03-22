//
//  Settings.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 25.10.23.
//

import Foundation

extension JourneySettings {
	init() {
		self.customTransferModes = []
		self.accessiblity = .partial
//		self.debugSettings = Self.ChewDebugSettings(prettyJSON: false, alternativeSearchPage: false)
		self.language = .english
		self.startWithWalking = true
		self.transferTime = .time(minutes: .zero)
		self.transportMode = .all
		self.walkingSpeed = .fast
		self.withBicycle = false
		self.transferCount = .unlimited
//		self.legViewMode = .sunEvents
	}
	init(settings : JourneySettings, onboarding : Bool) {
		self.customTransferModes = settings.customTransferModes
		self.accessiblity = settings.accessiblity
//		self.debugSettings = settings.debugSettings
		self.language = settings.language
		self.startWithWalking = settings.startWithWalking
		self.transferTime = settings.transferTime
		self.transportMode = settings.transportMode
		self.walkingSpeed = settings.walkingSpeed
		self.withBicycle = settings.withBicycle
		self.transferCount = settings.transferCount
//		self.legViewMode = settings.legViewMode
	}
}
