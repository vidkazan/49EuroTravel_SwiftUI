//
//  Settings.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 25.10.23.
//

import Foundation
import SwiftUI

struct AppSettings : Equatable,Hashable {
	let debugSettings : ChewDebugSettings
	let legViewMode : LegViewMode
	
	init() {
		self.debugSettings = ChewDebugSettings(prettyJSON: false, alternativeSearchPage: false)
		self.legViewMode = .sunEvents
	}
}

extension AppSettings {
	
	struct ChewDebugSettings: Equatable, Hashable {
		let prettyJSON : Bool
		let alternativeSearchPage : Bool
	}
	
	enum LegViewMode : Int16, Equatable,CaseIterable {
		case sunEvents
		case colorfulLegs
		case all
		
		var showSunEvents : Bool {
			switch self {
			case .colorfulLegs:
				return false
			default:
				return true
			}
		}
		var showColorfulLegs : Bool {
			switch self {
			case .sunEvents:
				return false
			default:
				return true
			}
		}
	}
}
