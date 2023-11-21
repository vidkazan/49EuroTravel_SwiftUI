//
//  BadgeView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 24.08.23.
//

import Foundation
import SwiftUI


// TODO: refactor badge service
struct BadgeView : View {
	var badge : Badges
	let isBig : Bool
	init(badge : Badges,isBig : Bool = false) {
		self.badge = badge
		self.isBig = isBig
	}
	var body : some View {
		switch badge {
		case .price,.cancelled,.connectionNotReachable,.alertFromRemark:
			Text(badge.badgeData.name)
				.font(.system(size: 12))
				.foregroundColor(.primary)
				.padding(4)
				.background(badge.badgeData.style)
				.cornerRadius(8)
				.lineLimit(1)
		case .dticket:
			DTicketLogo(fontSize: 17)
				.font(.system(size: 12))
				.padding(4)
				.background(badge.badgeData.style)
				.cornerRadius(8)
		case .lineNumber(lineType: let type, _):
			switch isBig {
			case true:
				Text(badge.badgeData.name)
					.chewTextSize(.big)
					.foregroundColor(.primary)
					.padding(4)
					.background( .linearGradient(
						colors: [
							badge.badgeData.style,
							type.color
						],
						startPoint: UnitPoint(x: 0, y: 0),
						endPoint: UnitPoint(x: 1, y: 0))
					)
					.cornerRadius(8)
					.lineLimit(1)
			case false:
				Text(badge.badgeData.name)
					.chewTextSize(.medium)
					.foregroundColor(.primary)
					.padding(4)
					.background( .linearGradient(
						colors: [
							badge.badgeData.style,
							type.color
						],
						startPoint: UnitPoint(x: 0, y: 0),
						endPoint: UnitPoint(x: 1, y: 0))
					)
					.cornerRadius(8)
					.lineLimit(1)
			}
		case .legDuration:
			HStack(spacing: 2) {
				Text(badge.badgeData.name)
					.chewTextSize(.medium)
					.foregroundColor(.secondary)
					.background(badge.badgeData.style)
					.lineSpacing(2)
					.lineLimit(1)
			}
			.padding(4)
			.background(Color.chewGray10)
			.cornerRadius(8)
		case .legDirection:
			switch isBig {
			case true:
				HStack(spacing: 2) {
					Text("to")
						.chewTextSize(.big)
						.foregroundColor(.secondary)
						.background(badge.badgeData.style)
						.lineSpacing(2)
						.lineLimit(1)
					Text(badge.badgeData.name)
						.chewTextSize(.big)
						.foregroundColor(.primary)
						.background(badge.badgeData.style)
						.lineSpacing(2)
						.lineLimit(1)
				}
				.padding(4)
				.background(Color.chewGray10)
				.cornerRadius(8)
			case false:
				HStack(spacing: 2) {
					Text("to")
						.chewTextSize(.medium)
						.foregroundColor(.secondary)
						.background(badge.badgeData.style)
						.lineSpacing(2)
						.lineLimit(1)
					Text(badge.badgeData.name)
						.chewTextSize(.medium)
						.foregroundColor(.primary)
						.background(badge.badgeData.style)
						.lineSpacing(2)
						.lineLimit(1)
				}
				.padding(4)
				.background(Color.chewGray10)
				.cornerRadius(8)
			}
		case .walking:
			HStack(spacing: 2) {
				Image(systemName: "figure.walk.circle")
					.chewTextSize(.medium)
					.foregroundColor(.secondary)
				Text("walk")
					.chewTextSize(.medium)
					.foregroundColor(.secondary)
					.background(badge.badgeData.style)
					.lineSpacing(2)
				Text(badge.badgeData.name)
					.chewTextSize(.medium)
					.foregroundColor(.primary)
					.background(badge.badgeData.style)
					.lineSpacing(2)
					.lineLimit(1)
			}
		case .transfer:
			HStack(spacing: 2) {
				Image(systemName: "arrow.triangle.2.circlepath")
					.chewTextSize(.medium)
					.foregroundColor(.primary)
				Text("transfer")
					.chewTextSize(.medium)
					.foregroundColor(.secondary)
					.background(badge.badgeData.style)
					.lineSpacing(2)
					.lineLimit(1)
				Text(badge.badgeData.name)
					.chewTextSize(.medium)
					.foregroundColor(.primary)
					.background(badge.badgeData.style)
					.lineSpacing(2)
					.lineLimit(1)
			}
		case .stopsCount:
			HStack(spacing: 2) {
				Text(badge.badgeData.name)
					.chewTextSize(.medium)
					.foregroundColor(.secondary)
					.background(badge.badgeData.style)
					.lineSpacing(2)
					.lineLimit(1)
			}
			.padding(4)
		}
	}
}
