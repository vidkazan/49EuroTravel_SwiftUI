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
					SearchFieldView(type: .arrival)
					TimeChoosingView()
				}
					.padding(EdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 5))
					.cornerRadius(10)
					.shadow(radius: 1,y:1)
				JourneyView()
					.frame(maxWidth: .infinity)
					.padding(EdgeInsets(top: 0, leading: 5, bottom: 5, trailing: 5))
					.cornerRadius(10)
			}
				.padding(5)
			if viewModel.isShowingDatePicker {
				VStack{
					DatePickerView(startDat: viewModel.timeChooserDate)
					Spacer()
				}
				.transition(.move(edge: .bottom))
				.animation(.spring(), value: viewModel.isShowingDatePicker)
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
			.animation(.spring(), value: viewModel.isShowingDatePicker)
			.animation(.spring(), value: viewModel.searchLocationDataDeparture)
			.animation(.spring(), value: viewModel.searchLocationDataArrival)
	}
}
