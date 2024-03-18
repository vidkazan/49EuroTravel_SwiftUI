//
//  LegDetailsStopView+badges.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 30.01.24.
//

import Foundation
import SwiftUI

extension LegStopView {
	var legStopViewBadges : some View {
		Group {
			if #available(iOS 16.0, *) {
				FlowLayout(spacing: .init(width: 2, height: 3)) {
					badges
				}
			} else {
				VStack(alignment: .leading,spacing: 3) {
					HStack(spacing: 2) {
						badges
					}
					BadgeView(
						.stopsCount(
							legViewData.legStopsViewData.count - 1,
							shevronIsExpanded == .collapsed ? .showShevronUp: .showShevronDown
						))
						.badgeBackgroundStyle(.secondary)
				}
			}
		}
	}
	var badges : some View {
		return Group {
			BadgeView(.lineNumber(
				lineType:legViewData.lineViewData.type ,
				num: legViewData.lineViewData.name
			))
			BadgeView(.legDirection(
				dir: legViewData.direction,
				strikethrough: false
			))
				.badgeBackgroundStyle(.secondary)
			BadgeView(
				.legDuration(legViewData.time)
			)
				.badgeBackgroundStyle(.secondary)
		}
	}
}
