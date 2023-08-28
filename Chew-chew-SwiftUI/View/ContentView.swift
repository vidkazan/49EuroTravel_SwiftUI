//
//  ContentView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 23.08.23.
//

import SwiftUI

struct ContentView: View {
	@EnvironmentObject var viewModel : SearchLocationViewModel
	var body: some View {
		ZStack {
			VStack {
				VStack{
					SearchFieldView(type: .departure)
					SearchFieldView(type: .arrival)
					TimeChoosingView()
				}
					.padding(5)
					.cornerRadius(10)
				JourneyCellView()
					.frame(maxWidth: .infinity)
					.padding(5)
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
					colors: [
						Color(hue: 0.55, saturation: 0.9, brightness: 0.6),
						Color(hue: 0.55, saturation: 1, brightness: 0.4),
					],
					startPoint: UnitPoint(x: 0.5, y: 0.33),
					endPoint: UnitPoint(x: 0.5, y: 0.9)
				)
			)
			.transition(.move(edge: .bottom))
			.animation(.spring(), value: viewModel.isShowingDatePicker)
			.animation(.spring(), value: viewModel.searchLocationDataDeparture)
			.animation(.spring(), value: viewModel.searchLocationDataArrival)
			
	}
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
			.environmentObject(SearchLocationViewModel())
    }
}



