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
						.transition(.move(edge: .bottom))
						.animation(.easeInOut, value: viewModel.searchLocationDataDeparture.count)
					SearchFieldView(type: .arrival)
						.transition(.move(edge: .bottom))
						.animation(.easeInOut, value: viewModel.searchLocationDataArrival.count)
					TimeChoosingView()
				}
					.padding(5)
//					.background(.ultraThinMaterial.opacity(0.4))
					.cornerRadius(10)
				JourneyCellView()
					.frame(maxWidth: .infinity)
					.padding(5)
					.cornerRadius(10)
					.transition(.move(edge: .bottom))
					.animation(.easeInOut, value: viewModel.resultJourneysCollectionViewDataSourse.journeys.count)
			}
				.transition(.move(edge: .bottom))
				.animation(.easeInOut, value: viewModel.resultJourneysCollectionViewDataSourse.journeys.count)
				.animation(.easeInOut, value: viewModel.searchLocationDataDeparture.count)
				.animation(.easeInOut, value: viewModel.searchLocationDataArrival.count)
				.padding(5)
//			if viewModel.isShowingDatePicker {
//				VStack{
//					DatePickerView()
//					Spacer()
//				}
//				.transition(.move(edge: .bottom))
//				.animation(.easeInOut, value: viewModel.isShowingDatePicker)
//			}
		}
			.transition(.move(edge: .bottom))
	
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
			
//			.animation(.easeInOut, value: viewModel.isShowingDatePicker)
			.animation(.easeInOut, value: viewModel.searchLocationDataDeparture.count)
			.animation(.easeInOut, value: viewModel.searchLocationDataArrival.count)
//			.animation(.easeInOut, value: viewModel.resultJourneysCollectionViewDataSourse.journeys.count)
			
	}
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
			.environmentObject(SearchLocationViewModel())
    }
}



