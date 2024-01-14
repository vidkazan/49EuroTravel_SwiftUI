//
//  TextModifiers.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.10.23.
//

import Foundation
import SwiftUI

protocol ChewTextStyle : ViewModifier {}

extension View {
	func chewTextSize<Style: ChewTextStyle>(_ style: Style) -> some View {
		ModifiedContent(content: self, modifier: style)
	}
}

extension ViewModifier where Self == ChewPrimaryStyle {
	static var big: ChewPrimaryStyle {
		ChewPrimaryStyle(17)
	}
}

extension ViewModifier where Self == ChewPrimaryStyle {
	static var small: ChewPrimaryStyle {
		ChewPrimaryStyle(9)
	}
}

extension ViewModifier where Self == ChewPrimaryStyle {
	static var medium: ChewPrimaryStyle {
		ChewPrimaryStyle(12)
	}
}

struct ChewPrimaryStyle: ChewTextStyle {
	let size : CGFloat!
	init(_ size : CGFloat){
		self.size = size
	}
	func body(content: Content) -> some View {
		content
			.font(.system(size: size,weight: .semibold))
	}
}
