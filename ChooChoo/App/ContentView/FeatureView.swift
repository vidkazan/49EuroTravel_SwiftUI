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
//	case debug
}

struct FeatureView: View {
	@EnvironmentObject var chewViewModel : ChewViewModel
	@State var selectedTab = Tabs.search
		
	
	let tabSearchLabel : some View = {
		Label(
			title: {
				Text("Search",comment : "TabItem")
			},
			icon: {
				Image(systemName: "magnifyingglass")
			}
		)
	}()
	let tabFollowLabel : some View = {
		Label(
			title: {
				Text("Follow", comment : "TabItem")
			},
			icon: {
				Image(ChewSFSymbols.bookmark)
			}
		)
	}()
	var handler: Binding<Tabs> { Binding(
		get: { self.selectedTab },
		set: {
			if $0 == self.selectedTab {
				switch selectedTab {
				case .search:
					chewViewModel.send(event: .didTapCloseJourneyList)
				case .follow:
					break
				}
			}
			self.selectedTab = $0
		}
	)}
	var body: some View {
		TabView(selection: handler) {
			if #available(iOS 16.0, *) {
				NavigationStack {
					JourneySearchView()
				}
					.tabItem { tabSearchLabel }
					.tag(Tabs.search)
				NavigationStack {
					JourneyFollowView()
				}
					.tabItem { tabFollowLabel }
					.tag(Tabs.follow)
			} else {
				NavigationView {
					JourneySearchView()
				}
					.tabItem { tabSearchLabel }
					.tag(Tabs.search)
				NavigationView {
					JourneyFollowView()
				}
					.tabItem { tabFollowLabel }
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

