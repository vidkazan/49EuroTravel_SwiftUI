//
//  ContentView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 23.08.23.
//

import SwiftUI

enum Tabs : Int,CaseIterable {
	case search
	case follow
//	case map
//	case settings
}

struct FeatureView: View {
//	@Environment(\.colorScheme) var colorScheme
	@EnvironmentObject var chewViewModel : ChewViewModel

	@State var selectedTab = Tabs.search
	var body: some View {
		TabView(selection: $selectedTab) {
			if #available(iOS 16.0, *) {
				NavigationStack {
					JourneySearchView()
				}
					.tabItem {
						Label("Search", systemImage: "magnifyingglass")
					}
					.tag(Tabs.search)
				NavigationStack {
					JourneyFollowView()
				}
					.tabItem {
						Label("Follow", systemImage: "train.side.front.car")
					}
					.tag(Tabs.follow)
//				NavigationStack {
//					MapPickerView(
//						vm: .init(.idle),
//						initialCoords: .init(latitude: 51.2, longitude: 6.6),
//						type: .departure,
//						close: {}
//					)
//				}
//					.tabItem {
//						Label("Map", systemImage: "map")
//					}
//					.tag(Tabs.map)
			} else {
				NavigationView {
					JourneySearchView()
				}
					.tabItem {
						Label("Search", systemImage: "magnifyingglass")
					}
					.tag(Tabs.search)
				NavigationView {
					JourneyFollowView()
				}
					.tabItem {
						Label("Follow", systemImage: "train.side.front.car")
					}
					.tag(Tabs.follow)
//				NavigationView {
//					MapPickerView(
//						vm: .init(.idle),
//						initialCoords: .init(latitude: 51.2, longitude: 6.6),
//						type: .departure,
//						close: {}
//					)
//				}
//					.tabItem {
//						Label("Map", systemImage: "map")
//					}
//					.tag(Tabs.map)
			}
		}
	}
}
