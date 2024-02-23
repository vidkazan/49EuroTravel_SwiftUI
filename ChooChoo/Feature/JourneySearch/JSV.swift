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
//				.animation(.smooth, value: searchStopsVM.state)
//				.animation(.smooth, value: chewViewModel
//					.state)
			BottomView()
		}
		.animation(.smooth, value: searchStopsVM.state)
		.animation(.smooth, value: chewViewModel
			.state)
		.contentShape(Rectangle())
		.onTapGesture {
			chewViewModel.send(event: .didCancelEditStop)
		}
		.padding(.horizontal,10)
		.background(Color.chewFillPrimary)
		.navigationTitle("Choo-Choo")
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
