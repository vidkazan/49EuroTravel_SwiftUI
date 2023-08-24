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
		VStack {
			ZStack {
				if viewModel.isShowingDatePicker {
					DatePickerView()
				}
				TimeChoosingView()
					.frame(alignment: .top)
					.offset(y:120)
				SearchFieldView(placeholder: "to")
					.frame(alignment: .top)
					.offset(y:80)
				SearchFieldView(placeholder: "from")
					.frame(alignment: .top)
					.offset(y:40)
			}
			Spacer()
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



