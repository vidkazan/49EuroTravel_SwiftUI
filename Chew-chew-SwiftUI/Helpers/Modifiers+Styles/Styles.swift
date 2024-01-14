//
//  Styles.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 12.01.24.
//

import Foundation
import SwiftUI

struct ChewLabelTextStyleBase: LabelStyle {
	let bgColor : Color
	init(bgColor : Color) {
		self.bgColor = bgColor
	}
	func makeBody(configuration: Configuration) -> some View {
		configuration.title
			.font(.system(size: 12,weight: .semibold))
			.padding(.horizontal,4)
			.padding(.vertical,2)
			.background(bgColor)
			.cornerRadius(6)
	}
}

struct ChewBigLabelTextStyleBig: LabelStyle {
	let bgColor : Color
	init(bgColor : Color) {
		self.bgColor = bgColor
	}
	func makeBody(configuration: Configuration) -> some View {
		configuration.title
			.font(.system(size: 17,weight: .semibold))
			.padding(.horizontal,4)
			.padding(.vertical,2)
			.background(bgColor)
			.cornerRadius(6)
	}
}
