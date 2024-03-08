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
	
	@EnvironmentObject var chewViewModel : ChewViewModel
	@ObservedObject var searchStopsVM = Model.shared.searchStopsViewModel
	var body: some View {
		VStack(spacing: 5) {
			if #available(iOS 17.0, *) {
				TipView(ChooTips.searchTip)
			}
			TopBarAlertsView()
			SearchStopsView()
			TimeAndSettingsView()
			BottomView()
		}
		.animation(.smooth, value: searchStopsVM.state)
		.animation(.smooth, value: chewViewModel
			.state)
		.contentShape(Rectangle())
//		.onTapGesture {
//			chewViewModel.send(event: .didCancelEditStop)
//		}
		.padding(.horizontal,10)
		.background(alignment: .top, content: {
			gradient()
		})
		.background(Color.chewFillPrimary)
		.navigationTitle("Choo Choo")
		.navigationBarTitleDisplayMode(.inline)
	}
}

extension JourneySearchView {
	@ViewBuilder func gradient() -> some View {
		ZStack {
			Rectangle().ignoresSafeArea(.all)
				.foregroundStyle(.clear)
				.background (
					.linearGradient(
						colors: [
							.transport.busMagenta.opacity(0.1),
							.transport.tramRed.opacity(0.05)
						],
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
							.transport.busMagenta.opacity(0.2),
							.transport.tramRed.opacity(0.1),
						],
						startPoint: UnitPoint(x: 0, y: 0),
						endPoint: UnitPoint(x: 1, y: 0))
				)
				.frame(maxWidth: .infinity, maxHeight: 170)
				.blur(radius: 50)
		}
	}
}

#Preview {
	JourneySearchView()
		.environmentObject(ChewViewModel(initialState: .init(
			depStop: .textOnly(""),
		 arrStop: .textOnly(""),
		 settings: .init(),
			date: .init(date: .now, mode: .departure),
		 status: .idle
	 )))
}
