//
//  ContentView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 23.08.23.
//

import SwiftUI
#warning("TODO: legView: place transport icons")
#warning("TODO: grouped animations with @namespaces https://gist.github.com/michael94ellis/5a46a5c2983da0cc99692b6659876fce")
#warning("TODO: error and alerts")

struct ContentView: View {
	@Environment(\.colorScheme) var colorScheme
	@EnvironmentObject var chewViewModel : ChewViewModel
	@State var state : ChewViewModel.State = .init()
	var body: some View {
		Group {
			if #available(iOS 16.0, *) {
				NavigationStack {
					switch state.status {
					case .start:
						EmptyView()
					default:
						VStack(spacing: 5) {
							AlertsView(alertVM: chewViewModel.alertViewModel)
							FeatureView()
						}
					}
				}
			} else {
				NavigationView {
					switch state.status {
					case .start:
						EmptyView()
					default:
						VStack(spacing: 5) {
							AlertsView(alertVM: chewViewModel.alertViewModel)
							FeatureView()
						}
					}
				}
			}
//			.sheet(
//				isPresented: $sheetIsPresented,
//				onDismiss: {
//					sheetIsPresented = false
//					chewViewModel.send(event: .didUpdateSettings(
//						ChewSettings(
//							settings: chewViewModel.state.settings,
//							onboarding: false
//						)
//					))
//					chewViewModel.coreDataStore.disableOnboarding()
//				},
//				content: {
//					if chewViewModel.state.settings.onboarding == true {
//						TabView {
//							Text("Onboarding Blabla 1")
//							Text("Onboarding Blabla 2")
//						}
//						.tabViewStyle(.page(indexDisplayMode: .always))
//					}
//				}
//			)
		}
		.onAppear {
			chewViewModel.send(event: .didStartViewAppear)
			UITabBar.appearance().backgroundColor = UIColor(Color.chewFillPrimary)
		}
		.onReceive(chewViewModel.$state, perform: { newState in
			state = newState
		})
	}
}
