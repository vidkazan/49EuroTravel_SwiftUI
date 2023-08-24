//
//  ContentView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 23.08.23.
//

import SwiftUI

final class ViewModel : ObservableObject {
	@Published var isShowingDatePicker = false
}

struct ContentView: View {
	@EnvironmentObject var viewModel : ViewModel
	var body: some View {
		ZStack {
			VStack {
				SearchFieldView(placeholder: "from")
				SearchFieldView(placeholder: "to")
				TimeChoosingView()
				Spacer()
			}
			.padding()
			if viewModel.isShowingDatePicker {
				DatePickerView()
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
			.environmentObject(ViewModel())
			
    }
}



