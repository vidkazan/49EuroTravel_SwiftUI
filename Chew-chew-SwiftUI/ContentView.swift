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
		VStack {
			ZStack {
				SearchFieldView(placeholder: "from")
					.frame(alignment: .top)
					.offset(y:40)
				SearchFieldView(placeholder: "to")
					.frame(alignment: .top)
					.offset(y:80)
				TimeChoosingView()
					.frame(alignment: .top)
					.offset(y:120)
				if viewModel.isShowingDatePicker {
					DatePickerView()
				}
			}
			Spacer()
		}
		.padding()
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
			.environmentObject(ViewModel())
			
    }
}
