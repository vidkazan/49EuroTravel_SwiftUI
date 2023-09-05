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
	@EnvironmentObject var viewModel : SearchLocationViewModel
	@EnvironmentObject private var viewModel2 : SearchJourneyViewModel
	let solar = Solar(coordinate: .init(
		latitude: 51.3,
		longitude: 9.4)
	)
	var body: some View {
		ZStack {
			VStack {
				VStack{
					SearchStopsView()
					TimeChoosingView()
				}
					.cornerRadius(10)
					.shadow(radius: 1,y:1)
					.padding(EdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 5))
				JourneyView()
				Spacer()
			}
				.padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
			if viewModel2.state == .datePicker {
//			if viewModel.searchLocationDataSource.isShowingDatePicker {
				VStack{
					DatePickerView(startDat: viewModel.searchLocationDataSource.timeChooserDate)
					Spacer()
				}
//				.transition(.move(edge: .bottom))
//				.animation(.spring(), value: viewModel.searchLocationDataSource.isShowingDatePicker)
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
//			.transition(.move(edge: .bottom))
//			.animation(.spring(), value: viewModel.searchLocationDataSource.isShowingDatePicker)
//			.animation(.spring(), value: viewModel.searchLocationDataSource.searchLocationDataDeparture)
//			.animation(.spring(), value: viewModel.searchLocationDataSource.searchLocationDataArrival)
	}
}

//struct ContentView_Previews: PreviewProvider {
//	static var previews: some View {
//		ContentView()
//			.environmentObject(SearchLocationViewModel())
//	}
//}
