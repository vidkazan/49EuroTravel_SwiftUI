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
				.background(Color.chewGray10)
				.cornerRadius(8)
				.lineLimit(1)
		case .dticket:
			DTicketLogo()
				.font(.system(size: 12))
				.padding(4)
				.background(badge.badgeData.style)
				.background(Color.chewGray10)
				.cornerRadius(8)
		case .lineNumber(lineType: let type, num: let num):
			Text(badge.badgeData.name)
				.font(.system(size: 12,weight: .semibold))
				.foregroundColor(.primary)
				.padding(4)
				.background(badge.badgeData.style)
				.background(Color.chewGray10)
				.cornerRadius(8)
				.lineLimit(1)
		case .legDuration(dur: let dur):
			HStack(spacing: 2) {
				Text(badge.badgeData.name)
					.font(.system(size: 12,weight: .semibold))
					.foregroundColor(.secondary)
					.background(badge.badgeData.style)
					.lineSpacing(2)
					.lineLimit(1)
			}
			.padding(4)
			.background(Color.chewGray10)
			.cornerRadius(8)
		case .legDirection(dir: let dir):
			HStack(spacing: 2) {
				Text("to")
					.font(.system(size: 12,weight: .semibold))
					.foregroundColor(.secondary)
					.background(badge.badgeData.style)
					.lineSpacing(2)
					.lineLimit(1)
				Text(badge.badgeData.name)
					.font(.system(size: 12,weight: .semibold))
					.foregroundColor(.primary)
					.background(badge.badgeData.style)
					.lineSpacing(2)
					.lineLimit(1)
			}
			.padding(4)
			.background(Color.chewGray10)
			.cornerRadius(8)
		case .walking(duration: let dur):
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
				Image(systemName: "arrow.triangle.2.circlepath")
					.font(.system(size: 12,weight: .semibold))
					.foregroundColor(.primary)
				Text("transfer")
					.font(.system(size: 12,weight: .semibold))
					.foregroundColor(.secondary)
					.background(badge.badgeData.style)
					.lineSpacing(2)
					.lineLimit(1)
				Text(badge.badgeData.name)
					.font(.system(size: 12,weight: .semibold))
					.foregroundColor(.primary)
					.background(badge.badgeData.style)
					.lineSpacing(2)
					.lineLimit(1)
			}
		case .stopsCount:
			HStack(spacing: 2) {
				Text(badge.badgeData.name)
					.font(.system(size: 12,weight: .semibold))
					.foregroundColor(.secondary)
					.background(badge.badgeData.style)
					.lineSpacing(2)
					.lineLimit(1)
			}
			.padding(4)
//			.cornerRadius(8)
		}
	}
}
