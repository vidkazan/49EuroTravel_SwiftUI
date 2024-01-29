//
//  ContentView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 23.08.23.
//

import SwiftUI
#warning("TODO: legView: place transport icons")
#warning("TODO: grouped animations with @namespaces https://gist.github.com/michael94ellis/5a46a5c2983da0cc99692b6659876fce")
#warning("TODO: bug: journey: if arrival stop cancelled, duration is NULL")
#warning("TODO: bug: journey: stop is showing totally cancelled if only exit / entrance is allowed")
#warning("TODO: error and alerts")

struct ContentView: View {
	@Environment(\.colorScheme) var colorScheme
	@EnvironmentObject var chewViewModel : ChewViewModel
	@State var state : ChewViewModel.State = .init()
	var body: some View {
		NavigationView {
			switch state.status {
			case .start:
				EmptyView()
			default:
				VStack(spacing: 5) {
					AlertsView(alertVM: chewViewModel.alertViewModel)
					FeatureView()
				}
//				.sheet(
//					isPresented: $sheetIsPresented,
//					onDismiss: {
//						sheetIsPresented = false
//						chewViewModel.send(event: .didUpdateSettings(
//							ChewSettings(
//								settings: chewViewModel.state.settings,
//								onboarding: false
//							)
//						))
//						chewViewModel.coreDataStore.disableOnboarding()
//					},
//					content: {
//						if chewViewModel.state.settings.onboarding == true {
//							TabView {
//								Text("Onboarding Blabla 1")
//								Text("Onboarding Blabla 2")
//							}
//							.tabViewStyle(.page(indexDisplayMode: .always))
//						}
//					}
//				)
			}
		}
//		.onChange(of: chewViewModel.state.status, perform: { _ in
//			sheetIsPresented = chewViewModel.state.settings.onboarding
//		})
		.onAppear {
			chewViewModel.send(event: .didStartViewAppear)
			UITabBar.appearance().backgroundColor = UIColor(Color.chewFillPrimary)
		}
		.onReceive(chewViewModel.$state, perform: { newState in
			state = newState
		})
	}
	
	struct ContentViewPreview : PreviewProvider {
		static var previews: some View {
			let mock = Mock.journeyList.journeyNeussWolfsburg.decodedData
			if let mock = mock {
				let viewData = constructJourneyListViewData(journeysData: mock,depStop: .init(),arrStop: .init())
				let data = JourneyListViewData(journeysViewData: viewData,data: mock,depStop: .init(),arrStop: .init())
				let vm = JourneyListViewModel(
					stops: .init(departure: .init(), arrival: .init()),
					viewData: data
				)
				Group {
					ContentView()
						.environmentObject(ChewViewModel(initialState: .init(
							depStop: .textOnly(""),
							arrStop: .textOnly(""),
							settings: .init(),
							date: .now,
							status: .journeys(.init(departure: .init(), arrival: .init()))
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
