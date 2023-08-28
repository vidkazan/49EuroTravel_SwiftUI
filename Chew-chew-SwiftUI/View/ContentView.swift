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
				SearchFieldView(type: .departure)
				SearchFieldView(type: .arrival)
				TimeChoosingView()
				JourneyView()
			}
			if viewModel.isShowingDatePicker {
				DatePickerView()
					.transition(.push(from: .bottom))
				Spacer()
			}
		}
		.padding()
	}
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
			.environmentObject(SearchLocationViewModel())
    }
}



