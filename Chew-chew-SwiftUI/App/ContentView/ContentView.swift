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
#warning("TODO: feature: reverse geocoding https://medium.com/aeturnuminc/geocoding-in-swift-611bda45efe1 or https://nominatim.openstreetmap.org/reverse?lon=10.78008628451338&lat=52.4212646484375&format=json&pretty=true")
#warning("feature: reverse geocoding: https://medium.com/@calmone/ios-mapkit-in-swift-4-reverse-geocoding-7fb9e41e8acd")
#warning("location request doesnt usually give actual location")


// TODO: feature: check when train arrives at starting point

struct ContentView: View {
	@Environment(\.colorScheme) var colorScheme
	@EnvironmentObject var chewViewModel : ChewViewModel
	@ObservedObject var sheetVM : SheetViewModel = Model.shared.sheetViewModel
	@State var state : ChewViewModel.State = .init()
	@State var sheetState : SheetViewModel.State = .init(status: .showing(.none, result: EmptyDataSource()))
	@State var sheetIsPresented = false
	var body: some View {
		Group {
			switch state.status {
			case .start:
				EmptyView()
			default:
				VStack(spacing: 5) {
					AlertsView()
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
	}
}
