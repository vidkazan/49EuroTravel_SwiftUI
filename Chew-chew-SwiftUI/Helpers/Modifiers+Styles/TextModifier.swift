//
//  TextModifiers.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.10.23.
//

import Foundation
import SwiftUI

enum ChewTextSize : Int, CaseIterable, Equatable {
	case small
	case medium
	case big
	case huge
	
	var chewTextStyle : ChewPrimaryStyle {
		switch self {
		case .small:
			return .small
		case .medium:
			return .medium
		case .big:
			return .big
		case .huge:
			return .huge
		}
	}
}

protocol ChewTextStyle : ViewModifier {}

extension View {
	func chewTextSize<Style: ChewTextStyle>(_ style: Style) -> some View {
		ModifiedContent(content: self, modifier: style)
	}
}

extension ViewModifier where Self == ChewPrimaryStyle {
	static var huge: ChewPrimaryStyle {
		ChewPrimaryStyle(20)
	}
	static var big: ChewPrimaryStyle {
		ChewPrimaryStyle(17)
	}
	static var small: ChewPrimaryStyle {
		ChewPrimaryStyle(9)
	}
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
