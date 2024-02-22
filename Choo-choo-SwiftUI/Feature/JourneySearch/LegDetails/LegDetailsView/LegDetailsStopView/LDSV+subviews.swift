//
//  LegDetailsView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 18.09.23.
//

import Foundation
import SwiftUI

extension LegStopView {

	var transfer : some View {
		VStack(alignment: .leading) {
			if stopOverType == .transfer {
				BadgeView(.transfer(legViewData.time))
			}
			if stopOverType == .footMiddle {
				BadgeView(.walking(legViewData.time))
			}
		}
		.offset(x: 78)
		.frame(maxWidth: .infinity,alignment: .leading)
		.frame(height: stopOverType.viewHeight)
	}
	
	var footBottom : some View {
		HStack(alignment: .bottom) {
			VStack(alignment: .leading) {
				Spacer()
				TimeLabelView(stopOver : stopOver,stopOverType: stopOverType)
				.background { timeLabelBackground }
				.cornerRadius(stopOverType.timeLabelCornerRadius)
				.shadow(radius: 2)
			}
			.frame(width: 70)
			VStack(alignment: .leading, spacing: 2) {
				BadgeView(.walking(legViewData.time))
				Text(stopOver.name)
					.chewTextSize(.big)
			}
			Spacer()
		}
		.frame(height: stopOverType.viewHeight)
	}
	
	var timeLabel : some View {
		VStack(alignment: .leading) {
			switch stopOverType {
			case .stopover:
				TimeLabelView(stopOver : stopOver,stopOverType: stopOverType)
					.frame(minWidth: 30)
				.background { timeLabelBackground }
				.cornerRadius(stopOverType.timeLabelCornerRadius)
				.shadow(radius: 2)
				.offset(x: stopOver.time.departureStatus.value != nil ? stopOver.time.departureStatus.value! > 0 ? 8 : 0 : 0)
			case .origin, .footTop,.destination:
				TimeLabelView(stopOver : stopOver,stopOverType: stopOverType)
					.frame(minWidth: 50)
				.background { timeLabelBackground }
				.cornerRadius(stopOverType.timeLabelCornerRadius)
				.shadow(radius: 2)
			case .footMiddle,.transfer,.footBottom:
				EmptyView()
			}
			Spacer()
		}
		.frame(width: 70)
	}
	
	var nameAndBadges : some View {
		VStack(alignment: .leading, spacing: 2) {
			// MARK: stopName sup Badges
			switch stopOverType {
			case .origin, .destination,.footTop:
				Text(stopOver.name)
					.strikethrough(stopOver.cancellationType() == .fullyCancelled ? true : false)
					.chewTextSize(.big)
			case .stopover:
				Text(stopOver.name)
					.strikethrough(stopOver.cancellationType() == .fullyCancelled ? true : false)
					.chewTextSize(.medium)
			case .transfer,.footBottom,.footMiddle:
				EmptyView()
			}
			// MARK: badges
			switch stopOverType {
			case .footBottom,.footMiddle,.footTop:
				BadgeView(.walking(legViewData.time))
			case .origin,.destination:
				PlatformView(
					isShowingPlatormWord: true,
					platform: stopOver.stopOverType.platform(stopOver: stopOver) ?? .init()
				)
				if showBadges == true, stopOverType == .origin {
					legStopViewBadges
				}
			case .transfer:
				BadgeView(.transfer(legViewData.time))
					.badgeBackgroundStyle(.accent)
			case .stopover:
				EmptyView()
			}
			// MARK: stopName sub Badges
			if case .footBottom = stopOverType {
				Text(stopOver.name)
					.chewTextSize(.big)
			}
		}
	}
}
