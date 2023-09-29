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
			Text(badge.badgeData.name)
				.font(.system(size: 12))
				.foregroundColor(.primary)
				.padding(4)
				.background(badge.badgeData.style)
//				.background(.ultraThinMaterial)
				.background(Color.chewGray15)
				.cornerRadius(8)
		case .dticket:
			DTicketLogo()
				.font(.system(size: 12))
				.padding(4)
				.background(badge.badgeData.style)
//				.background(.ultraThinMaterial)
				.background(Color.chewGray10)
				.cornerRadius(8)
		case .lineNumber:
			Text(badge.badgeData.name)
				.font(.system(size: 12,weight: .semibold))
				.foregroundColor(.primary)
				.padding(4)
				.background(badge.badgeData.style)
//				.background(.ultraThinMaterial)
				.background(Color.chewGray15)
				.cornerRadius(8)
		case .legDuration:
			HStack(spacing: 2) {
				Text(badge.badgeData.name)
					.font(.system(size: 12,weight: .semibold))
					.foregroundColor(.secondary)
					.background(badge.badgeData.style)
					.lineSpacing(2)
					.lineLimit(1)
			}
			.padding(4)
//			.background(.ultraThinMaterial)
			.background(Color.chewGray15)
			.cornerRadius(8)
		case .legDirection:
			HStack(spacing: 2) {
				Text("to")
					.font(.system(size: 12,weight: .semibold))
					.foregroundColor(.secondary)
					.background(badge.badgeData.style)
					.lineSpacing(2)
				Text(badge.badgeData.name)
					.font(.system(size: 12,weight: .semibold))
					.foregroundColor(.primary)
					.background(badge.badgeData.style)
					.lineSpacing(2)
					.lineLimit(1)
			}
			.padding(4)
//			.background(.ultraThinMaterial)
			.background(Color.chewGray15)
			.cornerRadius(8)
		case .walking:
			HStack(spacing: 2) {
				Image(systemName: "figure.walk.circle")
					.font(.system(size: 12,weight: .semibold))
					.foregroundColor(.secondary)
				Text("walk")
					.font(.system(size: 12,weight: .semibold))
					.foregroundColor(.secondary)
					.background(badge.badgeData.style)
					.lineSpacing(2)
				Text(badge.badgeData.name)
					.font(.system(size: 12,weight: .semibold))
					.foregroundColor(.primary)
					.background(badge.badgeData.style)
					.lineSpacing(2)
					.lineLimit(1)
			}
		case .transfer(duration: let duration):
			HStack(spacing: 2) {
				Image(systemName: "arrow.2.squarepath")
					.font(.system(size: 12,weight: .semibold))
					.foregroundColor(.secondary)
				Text("transfer")
					.font(.system(size: 12,weight: .semibold))
					.foregroundColor(.secondary)
					.background(badge.badgeData.style)
					.lineSpacing(2)
				Text(badge.badgeData.name)
					.font(.system(size: 12,weight: .semibold))
					.foregroundColor(.primary)
					.background(badge.badgeData.style)
					.lineSpacing(2)
					.lineLimit(1)
			}

		}
	}
}
