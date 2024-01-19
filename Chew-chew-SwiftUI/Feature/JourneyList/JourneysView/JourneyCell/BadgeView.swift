//
//  BadgeView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 24.08.23.
//

import Foundation
import SwiftUI

struct OneLineText : View {
	let text : String!
	init(_ text : String) {
		self.text = text
	}
	var body : some View {
		Text(text)
			.lineLimit(1)
	}
}

private struct UpdatedAtBadgeView : View {
	let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
	let refTime : Double
	let bgColor : Color
	let iconName : String?
	@State var updatedAt : String
	
	init(bgColor : Color, fgColor : Color = .primary, refTime : Double, sfIconName : String? = nil) {
		self.bgColor = bgColor
		self.refTime = refTime
		self.iconName = sfIconName
		self.updatedAt = Self.updatedAt(refTime: refTime)
	}
	
	var body : some View {
		Text("updated \(updatedAt) ago")
			.lineLimit(1)
			.foregroundColor(.primary.opacity(0.6))
			.onAppear {
				updatedAt = Self.updatedAt(refTime: self.refTime)
			}
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

struct BadgeView : View {
	var badge : Badges
	let size : ChewPrimaryStyle
	let color : Color = .chewFillTertiary
	init(_ badge : Badges,_ size : ChewPrimaryStyle = .medium, color : Color? = nil) {
		self.badge = badge
		self.size = size
	}
	var body : some View {
		Group {
			switch badge {
			case .offlineMode:
				OneLineText(badge.badgeData.name)
					.chewTextSize(size)
					.padding(4)
			case .timeDepartureTimeArrival(timeDeparture: let dep, timeArrival: let arr):
				OneLineText(dep + " - " + arr)
					.chewTextSize(size)
					.padding(4)
			case .date(let dateString):
				OneLineText(dateString)
					.chewTextSize(size)
					.padding(4)
			case .updatedAtTime(referenceTime: let refTime):
				UpdatedAtBadgeView(bgColor: self.color,fgColor: .primary,refTime: refTime)
					.chewTextSize(size)
					.padding(4)
			case .alertFromRemark:
				OneLineText(badge.badgeData.name)
					.chewTextSize(size)
					.padding(.horizontal,4)
					.padding(4)
			case .price,.cancelled,.connectionNotReachable:
				OneLineText(badge.badgeData.name)
					.chewTextSize(size)
					.padding(4)
			case .dticket:
				DTicketLogo(fontSize: 17)
					.font(.system(size: 12))
					.padding(2)
					.background(self.color)
					.cornerRadius(8)
					.padding(4)
			case .lineNumber(lineType: let type, _):
				HStack(spacing: 0) {
					Image(systemName: "train.side.front.car")
						.chewTextSize(size)
						.padding(.leading,2)
					OneLineText(badge.badgeData.name)
						.chewTextSize(size)
				}
				.padding(4)
				.badgeBackgroundStyle(BadgeBackgroundGradientStyle(colors: (.chewFillTertiary.opacity(0.5),type.color)))
			case .legDuration:
				OneLineText(badge.badgeData.name)
					.chewTextSize(size)
					.padding(4)
			case .stopsCount(let count,let mode):
				HStack(spacing: 2) {
					OneLineText(badge.badgeData.name)
						.chewTextSize(size)
					if count > 1, mode != .hideShevron {
						Image(systemName: "chevron.down.circle")
							.chewTextSize(size)
							.rotationEffect(.degrees(mode.angle))
							.animation(.spring(), value: mode)
					}
				}
				.padding(4)
			case .legDirection:
				HStack(spacing: 2) {
					OneLineText("to")
						.chewTextSize(size)
						.foregroundColor(.secondary)
					OneLineText(badge.badgeData.name)
						.chewTextSize(size)
				}
				.padding(4)
			case .walking:
				HStack(spacing: 2) {
					Image(systemName: "figure.walk.circle")
						.chewTextSize(size)
					OneLineText("walk")
						.chewTextSize(size)
						.foregroundColor(.secondary)
					OneLineText(badge.badgeData.name)
						.chewTextSize(size)
				}
				.padding(4)
			case .transfer:
				HStack(spacing: 2) {
					Image(systemName: "arrow.triangle.2.circlepath")
						.chewTextSize(size)
					OneLineText("transfer")
						.chewTextSize(size)
						.foregroundColor(.secondary)
					OneLineText(badge.badgeData.name)
						.chewTextSize(size)
				}
				.padding(4)
			case .departureArrivalStops(departure: let departure, arrival: let arrival):
				HStack(spacing: 2) {
					OneLineText(departure)
						.chewTextSize(size)
					Image(systemName: "arrow.right")
						.chewTextSize(size)
					OneLineText(arrival)
						.chewTextSize(size)
				}
				.padding(4)
			case .changesCount(let count):
				HStack(spacing: 2) {
					Image(systemName: "arrow.triangle.2.circlepath")
						.chewTextSize(size)
					OneLineText(String(count))
						.chewTextSize(size)
				}
				.padding(4)
			}
		}
	}
}

struct BadgeViewPreview : PreviewProvider {
	static var previews: some View {
		VStack(spacing: 5) {
			HStack {
				BadgeView(.changesCount(3))
					.badgeBackgroundStyle(.primary)
				BadgeView(.departureArrivalStops(departure: "Blablablablabla Hbf", arrival: "Plaplaplaplapla Hbf"),.big)
					.badgeBackgroundStyle(.primary)
			}
			HStack {
				BadgeView(.alertFromRemark)
					.badgeBackgroundStyle(.red)
				BadgeView(.cancelled)
					.badgeBackgroundStyle(.red)
				BadgeView(.connectionNotReachable)
					.badgeBackgroundStyle(.red)
			}
			HStack {
				BadgeView(.date(dateString: "12.12.2012"))
					.badgeBackgroundStyle(.primary)
				BadgeView(.legDuration(dur: "30 min"))
					.badgeBackgroundStyle(.primary)
				BadgeView(.dticket)
					.badgeBackgroundStyle(.primary)
			}
			BadgeView(.legDirection(dir: "Tudasudadudabuda Hbf"))
				.badgeBackgroundStyle(.primary)
			BadgeView(.legDirection(dir: "Tudasudadudabuda Hbf"),.big)
				.badgeBackgroundStyle(.primary)
			BadgeView(.lineNumber(lineType: .regionalExpress, num: "RE 666"),.big)
			HStack {
				BadgeView(.lineNumber(lineType: .regionalExpress, num: "RE 666"))
				BadgeView(.price("50EUR"))
					.badgeBackgroundStyle(.primary)
				BadgeView(.stopsCount(10,.showShevronDown),.medium)
					.badgeBackgroundStyle(.primary)
				BadgeView(.timeDepartureTimeArrival(timeDeparture: "10:00", timeArrival: "11:00"))
					.badgeBackgroundStyle(.primary)
			}
			HStack {
				BadgeView(.transfer(duration: "100 min"))
					.badgeBackgroundStyle(.primary)
				BadgeView(.updatedAtTime(referenceTime: 1705220000))
					.badgeBackgroundStyle(.primary)
				BadgeView(.walking(duration: "100 min"))
					.badgeBackgroundStyle(.primary)
			}
		}
	}
}
