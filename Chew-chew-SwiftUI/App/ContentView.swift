//
//  ContentView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 23.08.23.
//

import SwiftUI

struct ContentView: View {
	@Environment(\.colorScheme) var colorScheme
	@EnvironmentObject private var chewViewModel : ChewViewModel
	let solar = Solar(coordinate: .init(
		latitude: 51.3,
		longitude: 9.4)
	)
	var body: some View {
		NavigationView {
			ZStack {
				VStack(spacing: 5) {
					SearchStopsView(searchStopViewModel: chewViewModel.state.searchStopViewModel)
					TimeChoosingView(searchStopViewModel: chewViewModel.state.searchStopViewModel)
					if case .journeys(let vm) = chewViewModel.state.status {
						JourneysView(journeyViewModel: vm)
							.padding(.top,10)
					} else {
						Spacer()
					}
				}
				.padding(10)
				if chewViewModel.state.status == .datePicker {
					DatePickerView(startDat: chewViewModel.state.timeChooserDate.date)
				}
			}
			.background( .linearGradient(
				colors: colorScheme == .dark ? [.black] : [Color(hue: 0, saturation: 0, brightness: 0.85)],
				startPoint: UnitPoint(x: 0.5, y: 0.1),
				endPoint: UnitPoint(x: 0.5, y: 0.4))
			)
			.navigationBarTitle("")
			.navigationBarHidden(true)
			.transition(.move(edge: .bottom))
			.animation(.spring(), value: chewViewModel.state.status)
		}
	}
}
