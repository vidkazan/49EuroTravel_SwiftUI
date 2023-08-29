//
//  BadgeView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 24.08.23.
//

import Foundation
import SwiftUI

struct BadgeView : View {
	var text : String
	var color : Color
		init(badge : BadgeDataSource) {
			self.text = badge.name
			self.color = Color(badge.color)
		}
	var body : some View {
		Text(text)
			.font(.system(size: 12))
			.foregroundColor(.white)
			.padding(4)
			.background(color)
			.cornerRadius(8)
	}
}

struct BadgeView_Previews: PreviewProvider {
	static var previews: some View {
		BadgeView(badge: BadgeDataSource(color: .red, name: "cancelled"))
	}
}
