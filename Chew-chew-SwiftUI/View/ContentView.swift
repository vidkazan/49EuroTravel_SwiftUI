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
	
	static let day = Color(hue: 0.13, saturation: 0.55, brightness: 1)
	static let daySecondary = Color(hue: 0.13, saturation: 0.45, brightness: 0.9)
}

struct ContentView: View {
	@EnvironmentObject var viewModel : SearchLocationViewModel
	let solar = Solar(coordinate: .init(
		latitude: 51.3,
		longitude: 9.4))
	var body: some View {
		ZStack {
			VStack {
				VStack{
					SearchFieldView(type: .departure)
						.padding(EdgeInsets(top: 0, leading: 0, bottom: 1, trailing: 0))
					SearchFieldView(type: .arrival)
						.padding(EdgeInsets(top: 0, leading: 0, bottom: 1, trailing: 0))
					TimeChoosingView()
				}
					.cornerRadius(10)
					.shadow(radius: 1,y:1)
					.padding(EdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 5))
				JourneyView()
					.frame(maxWidth: .infinity)
					.cornerRadius(10)
					.padding(EdgeInsets(top: 0, leading: 5, bottom: 5, trailing: 5))
			}
				.padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
			if viewModel.searchLocationDataSource.isShowingDatePicker {
				VStack{
					DatePickerView(startDat: viewModel.searchLocationDataSource.timeChooserDate)
					Spacer()
				}
				.transition(.move(edge: .bottom))
				.animation(.spring(), value: viewModel.searchLocationDataSource.isShowingDatePicker)
			}
		}
			.background(
				.linearGradient(
					colors: (solar != nil && solar!.isDaytime) ?
						[Color.day,
						Color.daySecondary] :
						[Color.night,
						Color.nightSecondary],
					startPoint: UnitPoint(x: 0.5, y: 0.1),
					endPoint: UnitPoint(x: 0.5, y: 0.4)
				)
			)
			.transition(.move(edge: .bottom))
			.animation(.spring(), value: viewModel.searchLocationDataSource.isShowingDatePicker)
			.animation(.spring(), value: viewModel.searchLocationDataSource.searchLocationDataDeparture)
			.animation(.spring(), value: viewModel.searchLocationDataSource.searchLocationDataArrival)
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
			.environmentObject(SearchLocationViewModel())
	}
}
