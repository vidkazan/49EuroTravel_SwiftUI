//
//  BadgeView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 24.08.23.
//

import Foundation
import SwiftUI

struct BadgeView : View {
	var badge : Badges
	init(badge : Badges) {
		self.badge = badge
	}
	var body : some View {
		switch badge {
		case .price,.cancelled,.connectionNotReachable:
			Text(badge.badgeDataSourse.name)
				.font(.system(size: 12))
				.foregroundColor(.white)
				.padding(4)
				.background(Color(badge.badgeDataSourse.color))
				.cornerRadius(8)
		case .dticket:
			DTicketLogo()
				.font(.system(size: 12))
				.padding(4)
				.background(Color(badge.badgeDataSourse.color).opacity(0.5))
				.cornerRadius(8)
		}
	}
}
