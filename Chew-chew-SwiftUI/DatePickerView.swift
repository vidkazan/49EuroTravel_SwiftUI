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
	@State private var time = Date.now
    var body: some View {
		VStack {
			DatePicker(
				"",
				selection: $date,
				displayedComponents: [.date]
			)
				.datePickerStyle(.graphical)
				.padding()
			DatePicker(
				"",
				selection: $time,
				displayedComponents: [.hourAndMinute]
			)
				.datePickerStyle(.wheel)
				.padding()
			Button("Done") {
				viewModel.isShowingDatePicker = false
			}
			Spacer()
		}
		.background(Color.white)
	}
}

struct DatePickerView_Previews: PreviewProvider {
    static var previews: some View {
        DatePickerView()
    }
}
