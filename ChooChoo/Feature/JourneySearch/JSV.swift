//
//  JourneySearchView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 06.02.24.
//

import Foundation
import SwiftUI

struct JourneySearchView : View {
	
	@EnvironmentObject var chewViewModel : ChewViewModel
	@ObservedObject var searchStopsVM = Model.shared.searchStopsViewModel
	var body: some View {
		VStack(spacing: 5) {
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
//		.background( .linearGradient(
//			colors: [
//				.transport.tramRed.opacity(0.1),
//				.transport.busMagenta.opacity(0.05),
//				.chewFillPrimary
//			],
//			startPoint: UnitPoint(x: 0.2, y: 0),
//			endPoint: UnitPoint(x: 0.2, y: 0.4))
//		)
		.background(Color.chewFillPrimary)
		.navigationTitle("Choo Choo")
		.navigationBarTitleDisplayMode(.inline)
	}
}

#Preview {
	JourneySearchView()
		.environmentObject(ChewViewModel(initialState: .init(
			depStop: .textOnly(""),
		 arrStop: .textOnly(""),
		 settings: .init(),
		 date: .now,
		 status: .idle
	 )))
}
