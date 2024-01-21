//
//  ContentView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 23.08.23.
//

import SwiftUI

// TODO: place save / done buttons in sheet at top
// TODO: legView: place transport icons
// TODO: grouped animations with @namespaces https://gist.github.com/michael94ellis/5a46a5c2983da0cc99692b6659876fce
// TODO: .reducted (placeholder view) with mock data
// TODO: coreData: settings entity: save: update line instead of creating new
// TODO: move all logic from views
// TODO: bug: journey: if arrival stop cancelled, duration is NULL
// TODO: bug: journey: stop is showing totally cancelled if only exit / entrance is allowed

struct ContentView: View {
	@Environment(\.colorScheme) var colorScheme
	@EnvironmentObject var chewViewModel : ChewViewModel
	
	
	var body: some View {
		VStack(spacing: 0) {
			AlertView(alertVM: chewViewModel.alertViewModel)
			MainContentView()
		}
		.background(Color.chewFillPrimary)
	}
}

#warning("error and alerts")
#warning("recent rides")
#warning("favourite ride")

struct MainContentView: View {
	@Environment(\.colorScheme) var colorScheme
	@EnvironmentObject var chewViewModel : ChewViewModel
	@State var bottomSheetIsPresented : Bool = false
	
	var body: some View {
		NavigationView {
			TabView {
			switch chewViewModel.state.status {
			case .start:
				EmptyView()
			default:
					VStack(spacing: 0) {
						SearchStopsView(vm: chewViewModel.searchStopsViewModel)
							.padding(.horizontal,10)
						HStack {
							TimeChoosingView(searchStopsVM: chewViewModel.searchStopsViewModel)
							Button(action: {
								chewViewModel.send(event: .didTapSettings)
							}, label: {
								Image(systemName: "gearshape")
									.tint(.primary)
									.frame(maxWidth: 43,maxHeight: 43)
									.background(Color.chewFillAccent)
									.cornerRadius(8)
							})
						}
						.padding(EdgeInsets(top: 5, leading: 10, bottom: 0, trailing: 10))
						if case .journeys(let vm) = chewViewModel.state.status {
							JourneyListView(journeyViewModel: vm)
								.padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
						} else if case .idle = chewViewModel.state.status  {
							RecentSearchesView(recentSearchesVM: chewViewModel.recentSearchesViewModel)
								.padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
							Spacer()
						} else {
							Spacer()
						}
		#warning("https://serialcoder.dev/text-tutorials/swiftui/presenting-sheets-of-various-heights-in-swiftui/")
					}
					.background(Color.chewFillPrimary)
					.sheet(
						isPresented: $bottomSheetIsPresented,
						onDismiss: {
							chewViewModel.send(event: .didDismissBottomSheet)
						},
						content: {
							switch chewViewModel.state.status {
							case .settings:
								SettingsView(settings: chewViewModel.state.settings)
							case .datePicker:
								DatePickerView(
									date: chewViewModel.state.timeChooserDate.date,
									time: chewViewModel.state.timeChooserDate.date
								)
							default:
								EmptyView()
							}
						})
					.onChange(of: chewViewModel.state.status, perform: { status in
						switch status {
						case .datePicker,.settings:
							bottomSheetIsPresented = true
						default:
							bottomSheetIsPresented = false
						}
					})
//					.navigationBarHidden(true)
					.transition(.move(edge: .bottom))
					.animation(.spring().speed(2), value: chewViewModel.state.status)
					.animation(.spring().speed(2), value: chewViewModel.searchStopsViewModel.state.status)
					.animation(.spring().speed(2), value: chewViewModel.alertViewModel.state.status)
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
		.onAppear {
			chewViewModel.send(event: .didStartViewAppear)
			UITabBar.appearance().backgroundColor = UIColor(Color.chewFillAccent.opacity(0.5))
		}
	}
}

struct MainContentViewPreview : PreviewProvider {
	static var previews: some View {
		let mock = Mock.journeyList.journeyNeussWolfsburg.decodedData
		if let mock = mock {
			let viewData = constructJourneyListViewData(
				journeysData: mock,
				depStop: .init(),
				arrStop: .init()
			)
			let data = JourneyListViewData(
				journeysViewData: viewData,
				data: mock,
				depStop: .init(),
				arrStop: .init()
			)
			let vm = JourneyListViewModel(
				viewData: data
			)
			ContentView()
				.environmentObject(ChewViewModel())
		} else {
			Text("error")
		}
	}
}
