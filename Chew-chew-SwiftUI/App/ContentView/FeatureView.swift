//
//  ContentView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 23.08.23.
//

import SwiftUI

struct FeatureView: View {
	@Environment(\.colorScheme) var colorScheme
	@EnvironmentObject var chewViewModel : ChewViewModel
	@State var bottomSheetIsPresented : Bool = false

	var body: some View {
		TabView {
			Group {
				VStack(spacing: 5) {
					SearchStopsView(vm: chewViewModel.searchStopsViewModel)
					TimeAndSettingsView()
					BottomView()
				}
				.padding(.horizontal,10)
				.navigationTitle("ChewChew")
				.navigationBarTitleDisplayMode(.inline)
				.sheet(isPresented: $bottomSheetIsPresented,content: {sheet})
				.onChange(of: chewViewModel.state, perform: {_ in onStateChange()})
				.background(Color.chewFillPrimary)
			}
			.tabItem {
				Label("Search", systemImage: "magnifyingglass")
			}
			JourneyFollowView(viewModel: chewViewModel.journeyFollowViewModel)
			.tabItem {
				Label("Follow", systemImage: "train.side.front.car")
			}
		}
	}
}
