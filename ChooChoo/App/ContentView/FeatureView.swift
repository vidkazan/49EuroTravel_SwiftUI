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
			}
		}
		.onReceive(chewViewModel.$state, perform: { state in
			switch state.status {
			case .checkingSearchData:
				selectedTab = .search
			case .journeys:
				selectedTab = .search
			default:
				return
			}
		})
	}
}
