//
//  DatePickerView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 24.08.23.
//

import SwiftUI

struct DatePickerView: View {
	@EnvironmentObject var viewModel : ViewModel
	@State private var date = Date.now
    var body: some View {
		ZStack {
			VStack {
				DatePicker(
					"",
					selection: $date
				)
					.datePickerStyle(.graphical)
					.padding()
				Button("Done") {
					viewModel.isShowingDatePicker = false
				}
				Spacer()
			}
		}
		.background(Color.white)
		.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
	}
		
		
}

struct DatePickerView_Previews: PreviewProvider {
    static var previews: some View {
        DatePickerView()
    }
}
