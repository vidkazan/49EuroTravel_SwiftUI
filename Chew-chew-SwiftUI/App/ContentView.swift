//
//  ContentView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 23.08.23.
//

import SwiftUI

struct ContentView: View {
	@Environment(\.colorScheme) var colorScheme
	@EnvironmentObject private var searchJourneyViewModel : SearchJourneyViewModel
	let solar = Solar(coordinate: .init(
		latitude: 51.3,
		longitude: 9.4)
	)
	var body: some View {
		ZStack {
			VStack {
				SearchStopsView(searchStopViewModel: searchJourneyViewModel.state.searchStopViewModel)
				TimeChoosingView(searchStopViewModel: searchJourneyViewModel.state.searchStopViewModel)
				JourneysView()
			}
			.padding(10)
			.transition(.move(edge: .bottom))
			.animation(.spring(), value: searchJourneyViewModel.state.status)
			.animation(.spring(), value: searchJourneyViewModel.state.searchStopViewModel.state.status)
			if searchJourneyViewModel.state.status == .datePicker {
				DatePickerView(startDat: searchJourneyViewModel.state.timeChooserDate)
			}
		}
		.background( .linearGradient(
			colors: colorScheme == .dark ? [.black] : [Color(hue: 0, saturation: 0, brightness: 0.85)],
			startPoint: UnitPoint(x: 0.5, y: 0.1),
			endPoint: UnitPoint(x: 0.5, y: 0.4))
		)
		.transition(.move(edge: .bottom))
		.animation(.spring(), value: searchJourneyViewModel.state.status)
	}
}
