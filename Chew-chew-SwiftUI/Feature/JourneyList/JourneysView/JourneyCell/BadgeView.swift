//
//  BadgeView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 24.08.23.
//

import Foundation
import SwiftUI

struct ChewText : View {
	let text : String
	init(_ text : String) {
		self.text = text
	}
	var body: some View {
		Text(text)
			.padding(.vertical,4)
			.lineSpacing(2)
			.lineLimit(1)
	}
}

private struct BaseBadgeView : View {
	let text : String
	let bgColor : Color
	let fgColor : Color
	let iconName : String?
	init(bgColor : Color, fgColor : Color = .primary, text : String, sfIconName : String? = nil) {
		self.bgColor = bgColor
		self.fgColor = bgColor
		self.text = text
		self.iconName = sfIconName
	}
	var body : some View {
		ChewText(text)
			.foregroundColor(.primary)
			.padding(.horizontal,4)
			.background(bgColor)
			.cornerRadius(8)
	}
}


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
		case .updatedAtTime(dur: let duration):
			BaseBadgeView(
				bgColor: badge.badgeData.style,
				text: "updated " + duration + " ago"
			)
			.chewTextSize(.medium)
		case .price,.cancelled,.connectionNotReachable,.alertFromRemark:
			BaseBadgeView(
				bgColor: badge.badgeData.style,
				text: badge.badgeData.name
			)
			.chewTextSize(.medium)
		case .dticket:
			DTicketLogo(fontSize: 17)
				.font(.system(size: 12))
				.padding(4)
				.background(badge.badgeData.style)
				.cornerRadius(8)
		case .lineNumber(lineType: let type, _):
			switch isBig {
			case true:
				HStack(spacing: 0) {
					Image(systemName: "train.side.front.car")
						.chewTextSize(.big)
					ChewText(badge.badgeData.name)
						.padding(.horizontal,4)
						.chewTextSize(.big)
						.foregroundColor(.primary)
				}
				.background( .linearGradient(
					colors: [
						badge.badgeData.style,
						type.color
					],
					startPoint: UnitPoint(x: 0, y: 0),
					endPoint: UnitPoint(x: 1, y: 0))
				)
				.cornerRadius(8)
			case false:
				HStack(spacing: 0) {
					Image(systemName: "train.side.front.car")
						.chewTextSize(.medium)
					ChewText(badge.badgeData.name)
						.padding(.horizontal,4)
						.chewTextSize(.medium)
				}
				.background( .linearGradient(
					colors: [
						badge.badgeData.style,
						type.color
					],
					startPoint: UnitPoint(x: 0, y: 0),
					endPoint: UnitPoint(x: 1, y: 0))
				)
				.cornerRadius(6)
			}
		case .legDuration:
			BaseBadgeView(
				bgColor: badge.badgeData.style,
				fgColor: .secondary,
				text: badge.badgeData.name
			)
			.chewTextSize(.medium)
		case .stopsCount:
			BaseBadgeView(
				bgColor: Color.clear,
				fgColor: .secondary,
				text: badge.badgeData.name
			)
			.chewTextSize(.medium)
		case .legDirection:
			switch isBig {
			case true:
				HStack(spacing: 2) {
					ChewText("to")
						.chewTextSize(.big)
						.foregroundColor(.secondary)
					ChewText(badge.badgeData.name)
						.chewTextSize(.big)
				}
				.padding(4)
				.background(Color.chewGray10)
				.cornerRadius(8)
			case false:
				HStack(spacing: 2) {
					ChewText("to")
						.chewTextSize(.medium)
						.foregroundColor(.secondary)
					ChewText(badge.badgeData.name)
						.chewTextSize(.medium)
				}
				.padding(.horizontal,4)
				.background(badge.badgeData.style)
				.cornerRadius(8)
			}
		case .walking:
			HStack(spacing: 2) {
				Image(systemName: "figure.walk.circle")
					.chewTextSize(.medium)
				ChewText("walk")
					.chewTextSize(.medium)
					.foregroundColor(.secondary)
				ChewText(badge.badgeData.name)
					.chewTextSize(.medium)
			}
		case .transfer:
			HStack(spacing: 2) {
				Image(systemName: "arrow.triangle.2.circlepath")
					.chewTextSize(.medium)
				ChewText("transfer")
					.chewTextSize(.medium)
					.foregroundColor(.secondary)
				ChewText(badge.badgeData.name)
					.chewTextSize(.medium)
			}
		}
	}
}
