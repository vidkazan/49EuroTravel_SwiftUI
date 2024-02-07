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
		TabView {
			if #available(iOS 16.0, *) {
				NavigationStack {
					JourneySearchView()
				}
				.tabItem {
					Label("Search", systemImage: "magnifyingglass")
				}
				NavigationStack {
					JourneyFollowView()
				}
				.tabItem {
					Label("Follow", systemImage: "train.side.front.car")
				}
			} else {
				NavigationView {
					JourneySearchView()
				}
				.tabItem {
					Label("Search", systemImage: "magnifyingglass")
				}
				NavigationView {
					JourneyFollowView()
				}
				.tabItem {
					Label("Follow", systemImage: "train.side.front.car")
				}
			}
		}
	}
}
