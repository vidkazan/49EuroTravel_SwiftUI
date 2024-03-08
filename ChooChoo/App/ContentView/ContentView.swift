//
//  ContentView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 23.08.23.
//

import SwiftUI
import TipKit

#warning("TODO: localization")
#warning("FIX: iOS 16+ mapDetails: starting region fault")

// Lida ChooChoo to fix:

// MARK: JDV
// leg cell: stops number badge: let user know that cell is tappable and it will show all leg stops

// MARK: JFV
// emptyState: specify how to follow journey

// MARK: revise
// all text revision
// revise icons, espesially transfer icon
// revise contrast
// revise text white color ( too contrast with black BG )

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
				Text("ChooChoo")
					.chewTextSize(.huge)
			default:
				FeatureView()
					.animation(.smooth, value: topAlertVM.state)
			}
		}
		.task {
			if #available(iOS 17.0, *) {
				try? Tips.configure([
					.displayFrequency(.immediate),
					.datastoreLocation(.applicationDefault)
				])
			}
		}
		.alert(isPresented: $alertIsPresented, content: alert)
		.sheet(
			isPresented: $sheetIsPresented,
			onDismiss: {
				sheetIsPresented = false
			},
			content: {
				SheetView(closeSheet: {
					sheetIsPresented = false
				})
				.alert(isPresented: $alertIsPresented, content: alert)
			}
		)
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
		case let .destructive(destructiveAction, description, actionDescripton,_):
			return Alert(
				title: Text(description),
				primaryButton: .cancel(),
				secondaryButton: .destructive(
					Text(actionDescripton),
					action: destructiveAction
				)
			)
		case let .info(title, msg):
			return Alert(title: Text(title), message: Text(msg))
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
			date: .init(date: .now, mode: .departure),
			status: .idle
		)))
}
