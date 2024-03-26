//
//  ContentView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 23.08.23.
//

import SwiftUI
import TipKit

// learn content shape
// add all journeySettings

// MARK: revise
// all text revision
// revise icons
// tip: jfv: for swipe actions


// TODO: feature: ldsv: make stop tappable and show stop details and all leg stopover info
// TODO: jfv: mapCell: map without interaction, icons
// searchView: cell with nearest stop departures
struct ContentView: View {
	@EnvironmentObject var chewViewModel : ChewViewModel
	@ObservedObject var alertVM = Model.shared.alertViewModel
	@ObservedObject var sheetVM = Model.shared.sheetViewModel
	@ObservedObject var topAlertVM = Model.shared.topBarAlertViewModel
	
	@State var state = ChewViewModel.State()
	@State var sheetState = SheetViewModel.State(status: .showing(.none, result: EmptyDataSource()))
	@State var alertState = AlertViewModel.State(alert: .none)
	@State var sheetIsPresented = false
	@State var alertIsPresented = false
	
	var body: some View {
		Group {
			switch state.status {
			case .start:
				Text(verbatim: "ChooChoo")
					.chewTextSize(.huge)
			default:
				ZStack(alignment: .top) {
					FeatureView()
					TopBarAlertsView()
				}
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
		.confirmationDialog(
			"confirmation dialog",
			isPresented: Binding(
				get: { checkConfirmatioDialog(isSheet: false) },
				set: { _ in Model.shared.alertViewModel.send(event: .didRequestDismiss) }
			),
			actions: confirmationDialogActions,
			message: confirmationDialogMessage
		)
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
				.confirmationDialog(
					"confirmation dialog sheet",
					isPresented: Binding(
						get: { checkConfirmatioDialog(isSheet: true) },
						set: { _ in Model.shared.alertViewModel.send(event: .didRequestDismiss) }
					),
					actions: confirmationDialogActions,
					message: confirmationDialogMessage
				)
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
				sheetIsPresented = type != .none
			default:
				break
			}
		})
		.onReceive(alertVM.$state, perform: { newState in
			alertState = newState
		})
	}
}

extension ContentView {
	func checkConfirmatioDialog(isSheet : Bool) -> Bool {
		switch alertState.alert {
		case .none:
			return false
		case .destructive:
			return sheetIsPresented ? isSheet : !isSheet
		}
	}
}

extension ContentView {
	@ViewBuilder func confirmationDialogActions() -> some View {
		switch alertVM.state.alert {
		case .none:
			EmptyView()
		case .destructive(let destructiveAction, _, let actionDescription, _):
			Button(actionDescription, role: .destructive, action: destructiveAction)
		}
	}
	
	@ViewBuilder func confirmationDialogMessage() -> some View {
		switch alertState.alert {
		case .none:
			EmptyView()
		case .destructive(_, let description, _, _):
			Text(verbatim: description)
		}
	}
	
	func alert() -> Alert {
		switch alertState.alert {
		case let .destructive(destructiveAction, description, actionDescripton,_):
			return Alert(
				title: Text(verbatim: description) ,
				primaryButton: .cancel(),
				secondaryButton: .destructive(
					Text(verbatim: actionDescripton),
					action: destructiveAction
				)
			)
		case .none:
			return Alert(title: Text(verbatim: ""))
		}
	}
}
