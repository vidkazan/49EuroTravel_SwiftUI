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
				BadgeView(.transfer(duration: legViewData.duration))
			}
			if stopOverType == .footMiddle {
				BadgeView(.walking(duration: legViewData.duration))
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
				BadgeView(.walking(duration: legViewData.duration))
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
				.background { timeLabelBackground }
				.cornerRadius(stopOverType.timeLabelCornerRadius)
				.shadow(radius: 2)
				.offset(x: stopOver.timeContainer.departureStatus.value != nil ? stopOver.timeContainer.departureStatus.value! > 0 ? 8 : 0 : 0)
			case .origin, .footTop,.destination:
				TimeLabelView(stopOver : stopOver,stopOverType: stopOverType)
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
				BadgeView(.walking(duration: legViewData.duration))
			case .origin,.destination:
				PlatformView(
					isShowingPlatormWord: true,
					platform: stopOver.stopOverType.platform(stopOver: stopOver)?.actual,
					plannedPlatform: stopOver.stopOverType.platform(stopOver: stopOver)?.planned
				)
				if showBadges == true, stopOverType == .origin {
					legStopViewBadges
				}
			case .transfer:
				BadgeView(.transfer(duration: legViewData.duration))
			case .stopover:
				EmptyView()
			}
			// MARK: stopName sub Badges
			if case .footBottom = stopOverType{
				Text(stopOver.name)
					.chewTextSize(.big)
			}
		}
	}
}
