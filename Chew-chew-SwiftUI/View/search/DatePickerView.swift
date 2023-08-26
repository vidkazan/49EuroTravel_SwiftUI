//
//  DatePickerView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 24.08.23.
//

import SwiftUI

struct DatePickerView: View {
	@EnvironmentObject var viewModel : SearchLocationViewModel
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
				.background(Color.init(uiColor: .systemGray6))
				.cornerRadius(10)
			DatePicker(
				"",
				selection: $time,
				displayedComponents: [.hourAndMinute]
			)
			.environment(\.locale,NSLocale(localeIdentifier: "en_GB") as Locale)
				.datePickerStyle(.wheel)
				.padding()
				.background(Color.init(uiColor: .systemGray6))
				.cornerRadius(10)
			Button("Done") {
				viewModel.isShowingDatePicker = false
			}
			.padding()
			.frame(maxWidth: .infinity)
			.background(Color.init(uiColor: .systemGray4))
			.foregroundColor(Color.black)
			.cornerRadius(10)
			Spacer()
		}
		.padding()
		.background(Color.white)
	}
}

struct DatePickerView_Previews: PreviewProvider {
    static var previews: some View {
        DatePickerView()
    }
}
