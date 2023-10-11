//
//  TextModifiers.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.10.23.
//

import Foundation
import SwiftUI

extension View {
	func chewTextSize<Style: ViewModifier>(_ style: Style) -> some View {
		ModifiedContent(content: self, modifier: style)
	}
}

extension ViewModifier where Self == ChewPrimaryStyle {
	static var big: ChewPrimaryStyle { ChewPrimaryStyle() }
}

extension ViewModifier where Self == ChewSecondaryStyle {
	static var medium: ChewSecondaryStyle { ChewSecondaryStyle() }
}

struct ChewPrimaryStyle: ViewModifier {
	func body(content: Content) -> some View {
		content
			.font(.system(size: 17,weight: .semibold))
	}
}

struct ChewSecondaryStyle: ViewModifier {
	func body(content: Content) -> some View {
		content
			.font(.system(size: 12,weight: .medium))
	}
}
