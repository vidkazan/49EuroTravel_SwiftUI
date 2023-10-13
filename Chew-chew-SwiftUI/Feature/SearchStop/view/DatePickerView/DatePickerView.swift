//
//  DatePickerView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 24.08.23.
//

import SwiftUI

// TODO: move view to sheet
struct DatePickerView: View {
	@EnvironmentObject private var chewVM : ChewViewModel
	@State private var date = Date()
	@State private var time = Date()
	var startDate : Date
	init(sStartDate: Date = Date()) {
		startDate = sStartDate
	}
    var body: some View {
		VStack(alignment: .center) {
			HStack {
				DatePickerTimePresetButtons()
			}
				.frame(maxWidth: .infinity,maxHeight: 50)
				.background(.ultraThinMaterial)
				.cornerRadius(10)
			HStack {
				DatePicker(
					"",
					selection: $time,
					displayedComponents: [.hourAndMinute]
				)
					.environment(\.locale,NSLocale(localeIdentifier: "en_GB") as Locale)
					.datePickerStyle(.wheel)
					.cornerRadius(10)
					.padding(EdgeInsets(top: 7, leading: 7, bottom: 7, trailing: 15))
					.onAppear {
						UIDatePicker.appearance().minuteInterval = 5
						time = startDate
					}
				Spacer()
			}
				.frame(maxWidth: .infinity,maxHeight: 150)
				.background(.ultraThinMaterial)
				.cornerRadius(10)
			HStack {
				DatePicker(
					"",
					selection: $date,
					displayedComponents: [.date]
				)
				.onAppear {
					date = startDate
				}
				.datePickerStyle(.wheel)
				.padding(7)
				.cornerRadius(10)
				.padding(EdgeInsets(top: 0, leading: 0, bottom:0, trailing: 15))
			}
			.frame(maxWidth: .infinity,maxHeight: 150)
			.background(.ultraThinMaterial)
			.cornerRadius(10)
			Spacer()
			Button("Done") {
				if let dateCombined =  DateParcer.getCombinedDate(date: date, time: time) {
					chewVM.send(event: .onNewDate(.specificDate(dateCombined)))
				} else {
					chewVM.send(event: .onNewDate(.now))
				}
			}
				.frame(maxWidth: .infinity,minHeight: 43)
				.background(Color.chewGray10)
				.foregroundColor(.primary)
				.cornerRadius(10)
		}
		.padding(5)
		.cornerRadius(10)
		.padding(5)
	}
}
