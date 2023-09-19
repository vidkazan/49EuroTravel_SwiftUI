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
		case .price,.cancelled,.connectionNotReachable,.alertFromRemark:
			Text(badge.badgeDataSourse.name)
				.font(.system(size: 12))
				.foregroundColor(.primary)
				.padding(4)
				.background(badge.badgeDataSourse.style)
				.background(.ultraThinMaterial)
				.cornerRadius(8)
		case .dticket:
			DTicketLogo()
				.font(.system(size: 12))
				.padding(4)
				.background(badge.badgeDataSourse.style)
				.background(.ultraThinMaterial)
				.cornerRadius(8)
		case .lineNumber:
			Text(badge.badgeDataSourse.name)
				.font(.system(size: 12,weight: .semibold))
				.foregroundColor(.primary)
				.padding(4)
				.background(badge.badgeDataSourse.style)
				.background(.ultraThinMaterial)
				.cornerRadius(8)
		case .legDuration:
			HStack(spacing: 2) {
				Text(badge.badgeDataSourse.name)
					.font(.system(size: 12,weight: .semibold))
					.foregroundColor(.secondary)
					.background(badge.badgeDataSourse.style)
					.lineSpacing(2)
					.lineLimit(1)
			}
			.padding(4)
			.background(.ultraThinMaterial)
			.cornerRadius(8)
		case .legDirection:
			HStack(spacing: 2) {
				Text("to")
					.font(.system(size: 12,weight: .semibold))
					.foregroundColor(.secondary)
					.background(badge.badgeDataSourse.style)
					.lineSpacing(2)
				Text(badge.badgeDataSourse.name)
					.font(.system(size: 12,weight: .semibold))
					.foregroundColor(.primary)
					.background(badge.badgeDataSourse.style)
					.lineSpacing(2)
					.lineLimit(1)
			}
			.padding(4)
			.background(.ultraThinMaterial)
			.cornerRadius(8)
		}
	}
}
