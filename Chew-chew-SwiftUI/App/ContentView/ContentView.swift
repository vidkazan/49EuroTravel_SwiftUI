//
//  ContentView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 23.08.23.
//

import SwiftUI

#warning("TODO: make error view")
#warning("TODO: localization")
#warning("TODO: legView: place transport icons")
#warning("TODO: grouped animations with @namespaces https://gist.github.com/michael94ellis/5a46a5c2983da0cc99692b6659876fce")
#warning("TODO: confirmation of destructive actions")
#warning("location request doesnt usually give actual location")


// TODO: feature: check when train arrives at starting point
// TODO: feature: pick location on map + show stops on map

struct ContentView: View {
	@Environment(\.colorScheme) var colorScheme
	@EnvironmentObject var chewViewModel : ChewViewModel
	@ObservedObject var alertVM = Model.shared.alertViewModel
	@ObservedObject var sheetVM = Model.shared.sheetViewModel
	@State var state : ChewViewModel.State = .init()
	@State var sheetState = SheetViewModel.State(status: .showing(.none, result: EmptyDataSource()))
	@State var alertState = AlertViewModel.State(alert: .none)
	@State var sheetIsPresented = false
	@State var alertIsPresented = false
	var body: some View {
		Group {
			switch state.status {
			case .start:
				EmptyView()
			default:
				VStack(spacing: 5) {
					TopBarAlertsView()
					FeatureView()
				}
			}
		}
		.sheet(
			isPresented: $sheetIsPresented,
			onDismiss: {
				sheetIsPresented = false
			},
			content: {
				SheetView(closeSheet: {
					sheetIsPresented = false
				})
			}
		)
		.alert(isPresented: $alertIsPresented, content: alert)
		.background(Color.chewFillPrimary)
		.onAppear {
			chewViewModel.send(event: .didStartViewAppear)
			UITabBar.appearance().backgroundColor = UIColor(Color.chewFillPrimary)
		}
		.onReceive(chewViewModel.$state, perform: { newState in
			state = newState
		})
		.onReceive(sheetVM.$state, perform: { newState in
			sheetState = newState
			switch newState.status {
			case .loading(let type),.showing(let type, _):
				switch type {
				case .none:
					sheetIsPresented = false
				default:
					sheetIsPresented = true
				}
			default:
				break
			}
		})
		.onReceive(alertVM.$state, perform: { newState in
			alertState = newState
			switch alertState.alert {
				case .none:
					alertIsPresented = false
				default:
					alertIsPresented = true
				}
		})
	}
	
	func alert() -> Alert {
		switch alertState.alert {
		case let .destructive(destructiveAction, description, actionDescripton):
			return Alert(
				title: Text(description),
				primaryButton: .cancel(),
				secondaryButton: .destructive(
					Text(actionDescripton),
					action: destructiveAction
				)
			)
		case .none:
			return Alert(title: Text("Test alert"))
		}
	}
}
