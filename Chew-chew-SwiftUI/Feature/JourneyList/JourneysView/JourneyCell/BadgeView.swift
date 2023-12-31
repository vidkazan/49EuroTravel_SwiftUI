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

private struct UpdatedAtBadgeView : View {
	let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
	
	let refTime : Double
	let bgColor : Color
	let fgColor : Color
	let iconName : String?
	@State var updatedAt : String
	init(bgColor : Color, fgColor : Color = .primary, refTime : Double, sfIconName : String? = nil) {
		self.bgColor = bgColor
		self.fgColor = bgColor
		self.refTime = refTime
		self.iconName = sfIconName
		self.updatedAt = Self.updatedAt(refTime: refTime)
	}
	var body : some View {
		ChewText("updated \(updatedAt) ago")
			.foregroundColor(.primary.opacity(0.7))
			.padding(.horizontal,4)
			.background(bgColor)
			.cornerRadius(8)
			.onReceive(timer, perform: { _ in
				updatedAt = Self.updatedAt(refTime: self.refTime)
			})
	}
	static func updatedAt(refTime : Double) -> String {
		DateParcer.getTimeStringWithHoursAndMinutesFormat(minutes: DateParcer.getTwoDateIntervalInMinutes(
			date1: Date(timeIntervalSince1970: .init(floatLiteral: refTime)),
			date2: .now)) ?? "error"
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
	let color : Color
	init(badge : Badges,isBig : Bool = false, color : Color? = nil) {
		self.badge = badge
		self.isBig = isBig
		self.color = color ?? badge.badgeData.style
	}
	var body : some View {
		switch badge {
		case .timeDepartureTimeArrival(timeDeparture: let dep, timeArrival: let arr):
			BaseBadgeView(
				bgColor: self.color,
				text: dep + " - " + arr
			)
			.chewTextSize(.medium)
		case .date(let dateString):
			BaseBadgeView(
				bgColor: self.color,
				text: dateString
			)
			.chewTextSize(.medium)
		case .updatedAtTime(referenceTime: let refTime):
			UpdatedAtBadgeView(
				bgColor: self.color,
				fgColor: .primary.opacity(1),
				refTime: refTime
			)
			.chewTextSize(.medium)
		case .price,.cancelled,.connectionNotReachable,.alertFromRemark:
			BaseBadgeView(
				bgColor: self.color,
				text: badge.badgeData.name
			)
			.chewTextSize(.medium)
		case .dticket:
			DTicketLogo(fontSize: 17)
				.font(.system(size: 12))
				.padding(4)
				.background(self.color)
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
						self.color,
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
						self.color,
						type.color
					],
					startPoint: UnitPoint(x: 0, y: 0),
					endPoint: UnitPoint(x: 1, y: 0))
				)
				.cornerRadius(6)
			}
		case .legDuration:
			BaseBadgeView(
				bgColor: self.color,
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
				.background(self.color)
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
