//
//  ContentView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 23.08.23.
//

import SwiftUI
#warning("TODO: split chewVM reducer")
#warning("TODO: legView: place transport icons")
#warning("TODO: grouped animations with @namespaces https://gist.github.com/michael94ellis/5a46a5c2983da0cc99692b6659876fce")
#warning("TODO: .reducted (placeholder view) with mock data")
#warning("TODO: bug: journey: if arrival stop cancelled, duration is NULL")
#warning("TODO: bug: journey: stop is showing totally cancelled if only exit / entrance is allowed")
#warning("TODO: error and alerts")
#warning("TODO: favourite ride")
#warning("TODO: sheet detents")

struct ContentView: View {
	@Environment(\.colorScheme) var colorScheme
	@EnvironmentObject var chewViewModel : ChewViewModel
	
	
	var body: some View {
		VStack(spacing: 0) {
			AlertView(alertVM: chewViewModel.alertViewModel)
			MainContentView()
		}
		.onAppear {
			chewViewModel.send(event: .didStartViewAppear)
			UITabBar.appearance().backgroundColor = UIColor(Color.chewFillPrimary)
		}
	}
}

struct MainContentView: View {
	@Environment(\.colorScheme) var colorScheme
	@EnvironmentObject var chewViewModel : ChewViewModel
	@State var bottomSheetIsPresented : Bool = false
	
	var body: some View {
		NavigationView {
			TabView {
				Group {
					switch chewViewModel.state.status {
					case .start:
						EmptyView()
					default:
						VStack(spacing: 0) {
							SearchStopsView(vm: chewViewModel.searchStopsViewModel)
								.padding(.horizontal,10)
								.padding(.top,10)
							TimeAndSettingsView()
								.padding(EdgeInsets(top: 5, leading: 10, bottom: 0, trailing: 10))
							BottomView()
								.padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
						}
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
						.transition(.move(edge: .bottom))
						.animation(.spring().speed(2), value: chewViewModel.state.status)
						.animation(.spring().speed(2), value: chewViewModel.searchStopsViewModel.state.status)
						.animation(.spring().speed(2), value: chewViewModel.alertViewModel.state.status)
						.background(Color.chewFillPrimary)
					}
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
				Group {
					ContentView()
						.environmentObject(ChewViewModel(initialState: .init(
							depStop: .textOnly(""),
							arrStop: .textOnly(""),
							settings: .init(),
							timeChooserDate: .now,
							status: .journeys(vm)
						)))
					ContentView()
						.environmentObject(ChewViewModel())
				}
			} else {
				Text("error")
			}
		}
	}
}
