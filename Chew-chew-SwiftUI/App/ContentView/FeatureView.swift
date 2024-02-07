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

	var body: some View {
		if #available(iOS 16.0, *) {
			TabView {
				NavigationStack {
					JourneySearchView()
						.background(Color.chewFillPrimary)
				}
				.tabItem {
					Label("Search", systemImage: "magnifyingglass")
				}
				NavigationStack {
					JourneyFollowView(viewModel: chewViewModel.journeyFollowViewModel)
						.background(Color.chewFillPrimary)
				}
				.tabItem {
					Label("Follow", systemImage: "train.side.front.car")
				}
			}
			.background(Color.chewFillPrimary)
		} else {
			TabView {
				NavigationView {
					JourneySearchView()
						.background(Color.chewFillPrimary)
				}
				.tabItem {
					Label("Search", systemImage: "magnifyingglass")
				}
				NavigationView {
					JourneyFollowView(viewModel: chewViewModel.journeyFollowViewModel)
						.background(Color.chewFillPrimary)
				}
				.tabItem {
					Label("Follow", systemImage: "train.side.front.car")
				}
			}
			.background(Color.chewFillPrimary)
		}
	}
}
