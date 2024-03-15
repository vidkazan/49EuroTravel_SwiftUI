//
//  ContentView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 23.08.23.
//

import SwiftUI
import TipKit

#warning("FIX: iOS 17+ mapDetails: starting region fault")
#warning("prognosed direction")

// MARK: JDV
// leg cell: stops number badge: let user know that cell is tappable and it will show all leg stops

// MARK: revise
// all text revision
// revise icons
// revise contrast
// revise text white color ( too contrast with black BG )

#warning("Anna")
// tip: for sunEvents ( first cell of journeyList )
// tip: jfv: for swipe actions


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
				Text(verbatim: "ChooChoo")
					.chewTextSize(.huge)
			default:
				FeatureView()
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
				title: description,
				primaryButton: .cancel(),
				secondaryButton: .destructive(
					actionDescripton,
					action: destructiveAction
				)
			)
		case let .info(title, msg):
			return Alert(title: title, message: msg)
		case .none:
			return Alert(title: Text(verbatim: ""))
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
