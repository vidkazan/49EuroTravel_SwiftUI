//
//  CustomEnvironments.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 04.02.24.
//

import Foundation
import SwiftUI

enum LegsViewHeightMultiplierKey: EnvironmentKey {
	static var defaultValue: Double = 1
}

extension EnvironmentValues {
	var legsViewMultiplierKey: Double {
		get {
			self[LegsViewHeightMultiplierKey.self]
		}
		set {
			self[LegsViewHeightMultiplierKey.self] = newValue
		}
	}
}
