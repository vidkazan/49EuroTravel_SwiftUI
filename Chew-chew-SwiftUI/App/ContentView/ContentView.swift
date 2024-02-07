//
//  ContentView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 23.08.23.
//

import SwiftUI
#warning("TODO: localization")
#warning("TODO: legView: place transport icons")
#warning("TODO: grouped animations with @namespaces https://gist.github.com/michael94ellis/5a46a5c2983da0cc99692b6659876fce")
#warning("TODO: confirmation of destructive actions")

struct ContentView: View {
	@Environment(\.colorScheme) var colorScheme
	@EnvironmentObject var chewViewModel : ChewViewModel
	@ObservedObject var sheetVM : SheetViewModel
	@State var state : ChewViewModel.State = .init()
	var body: some View {
		Group {
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
		.sheet(
			isPresented: sheetVM.state.status.sheetIsPresented,
			onDismiss: {
				sheetVM.send(event: .didRequestHide)
			},
			content: {
				SheetView(sheetVM: chewViewModel.sheetViewModel)
			}
		)
		.background(Color.chewFillPrimary)
		.onAppear {
			chewViewModel.send(event: .didStartViewAppear)
			UITabBar.appearance().backgroundColor = UIColor(Color.chewFillPrimary)
		}
		.onReceive(chewViewModel.$state, perform: { newState in
			state = newState
		})
	}
}
