//
//  Color+random.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 29.01.24.
//

import Foundation
import SwiftUI

extension Color {
	static var random: Color {
		return Color(
			red: .random(in: 0...1),
			green: .random(in: 0...1),
			blue: .random(in: 0...1)
		)
	}
	static var randomBlue: Color {
		return Color(
			red: 0.2,
			green: 0.2,
			blue: .random(in: 0.4...1)
		)
	}
	static var randomRed: Color {
		return Color(
			red: .random(in: 0.2...0.5),
			green: 0.2,
			blue: 0.2
		)
	}
}
