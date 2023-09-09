//
//  ContentView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 23.08.23.
//

import SwiftUI

extension Color {
	static let night = Color(hue: 0.57, saturation: 0.7, brightness: 0.6)
	static let nightSecondary = Color(hue: 0.57, saturation: 0.5, brightness: 0.7)
}

struct ContentView: View {
	@EnvironmentObject private var searchJourneyViewModel : SearchJourneyViewModel
	@ObservedObject var searchStopViewModel : SearchLocationViewModel
	let solar = Solar(coordinate: .init(
		latitude: 51.3,
		longitude: 9.4)
	)
	var body: some View {
		ZStack {
			VStack {
				VStack{
					SearchStopsView(searchStopViewModel: searchJourneyViewModel.state.searchStopViewModel)
					TimeChoosingView()
				}
					.cornerRadius(10)
					.shadow(radius: 1,y:1)
					.padding(EdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 5))
				JourneysView()
					.transition(.move(edge: .bottom))
					.animation(.spring(), value: searchJourneyViewModel.state.status)
					.animation(.spring(), value: searchJourneyViewModel.state.searchStopViewModel.state)
			}
				.padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
				.transition(.move(edge: .bottom))
				.animation(.spring(), value: searchJourneyViewModel.state.status)
				.animation(.spring(), value: searchJourneyViewModel.state.searchStopViewModel.state)
			if searchJourneyViewModel.state.status == .datePicker {
				VStack{
					DatePickerView(startDat: searchJourneyViewModel.state.timeChooserDate)
					Spacer()
				}
				.transition(.move(edge: .bottom))
				.animation(.spring(), value: searchJourneyViewModel.state.status)
			}
		}
			.background(
				.linearGradient(colors:
						[Color.night,
						Color.nightSecondary],
					startPoint: UnitPoint(x: 0.5, y: 0.1),
					endPoint: UnitPoint(x: 0.5, y: 0.4)
				)
			)
			.transition(.move(edge: .bottom))
			.animation(.spring(), value: searchJourneyViewModel.state.status)
			.animation(.spring(), value: searchJourneyViewModel.state.searchStopViewModel.state)
	}
}
