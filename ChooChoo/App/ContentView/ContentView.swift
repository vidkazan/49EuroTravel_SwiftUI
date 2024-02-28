//
//  ContentView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 23.08.23.
//

import SwiftUI

#warning("TODO: make error view")
#warning("TODO: localization")
#warning("TODO: grouped animations with @namespaces https://gist.github.com/michael94ellis/5a46a5c2983da0cc99692b6659876fce")

// Lida ChooChoo to fix:


// MARK: JDV
// leg cell: stops number badge: let user know that cell is tappable and it will show all leg stops

// MARK: JFV
// emptyState: specify how to follow journey
// cell: swipe actions: let user repeat (past) followed journey


// MARK: Settings
// let user know that some settings are filtrating search results
// remove debug options



// all text revision
// RSV: leave only last 5 items
// SSV: stopList: swap right icons
// revise icons, espesially transfer icon

//  revise contrast
//  revise text white color ( too contrast with black BG )
//  DESIGGGGN: add some gradient?


// TODO: feature: check when train arrives at starting point

struct ContentView: View {
	@EnvironmentObject var chewViewModel : ChewViewModel
	@ObservedObject var alertVM = Model.shared.alertViewModel
	@ObservedObject var sheetVM = Model.shared.sheetViewModel
	@ObservedObject var topAlertVM = Model.shared.topBarAlertViewModel
	
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
						.animation(.smooth, value: topAlertVM.state)
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
}

extension ContentView {
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

#Preview {
	ContentView()
		.environmentObject(ChewViewModel(initialState: .init(
			depStop: .textOnly(""),
			arrStop: .textOnly(""),
			settings: .init(),
			date: .now,
			status: .idle
		)))
}
