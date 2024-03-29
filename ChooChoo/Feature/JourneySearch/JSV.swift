//
//  JourneySearchView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 06.02.24.
//

import Foundation
import SwiftUI
import TipKit

struct JourneySearchView : View {
	@Namespace var journeySearchViewNamespace
	@EnvironmentObject var chewViewModel : ChewViewModel
	@ObservedObject var searchStopsVM = Model.shared.searchStopsViewModel
	@ObservedObject var topAlertVM = Model.shared.topBarAlertViewModel
	var body: some View {
		VStack(spacing: 5) {
			if #available(iOS 17.0, *) {
				TipView(ChooTips.searchTip)
			}
			SearchStopsView()
			TimeAndSettingsView()
			BottomView()
		}
		.contentShape(Rectangle())
		.padding(.horizontal,10)
		.background(alignment: .top, content: {
			gradient()
		})
		.background(Color.chewFillPrimary)
		.navigationTitle(
			Text(verbatim: "Choo Choo")
		)
		.navigationBarTitleDisplayMode(.inline)
		.toolbar {
			ToolbarItem(
				placement: .topBarTrailing,
				content: {
					if topAlertVM.state.alerts.contains(.offline) {
						BadgeView(.offlineMode)
							.badgeBackgroundStyle(.blue)
					}
				}
			)
		}
	}
}

extension JourneySearchView {
	static let colors : [Color] = {
		#if DEBUG
		debugColors
		#else
		releaseColors
		#endif
	}()
	static private let releaseColors = [
		Color.transport.uBlue.opacity(0.1),
		Color.transport.shipCyan.opacity(0.05)
	]
	static private let debugColors = [
		Color.transport.tramRed.opacity(0.4),
		Color.transport.tramRed.opacity(0.2)
	]
	@ViewBuilder func gradient() -> some View {
		ZStack {
			Rectangle().ignoresSafeArea(.all)
				.foregroundStyle(.clear)
				.background (
					.linearGradient(
						colors: Self.colors,
						startPoint: UnitPoint(x: 0.2, y: 0),
						endPoint: UnitPoint(x: 0.2, y: 0.4)
					)
				)
				.frame(maxWidth: .infinity, maxHeight: 170)
				.blur(radius: 50)
			Rectangle()
				.foregroundStyle(.clear)
				.background (
					.linearGradient(
						colors: [
							.transport.shipCyan.opacity(0.2),
							.transport.uBlue.opacity(0.1),
						],
						startPoint: UnitPoint(x: 0, y: 0),
						endPoint: UnitPoint(x: 1, y: 0))
				)
				.frame(maxWidth: .infinity, maxHeight: 170)
				.blur(radius: 50)
		}
	}
}
