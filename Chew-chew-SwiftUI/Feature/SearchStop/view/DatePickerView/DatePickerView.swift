//
//  DatePickerView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 24.08.23.
//

import SwiftUI

// MARK: load it quiker
struct DatePickerView: View {
	@EnvironmentObject private var chewVM : ChewViewModel
	@State var date : Date
	@State var time : Date
	var body: some View {
		VStack(alignment: .center) {
			HStack {
				DatePickerTimePresetButtons()
			}
			.frame(maxWidth: .infinity,maxHeight: 50)
			.background(Color.chewGrayScale15)
			.cornerRadius(10)
			.padding(.vertical,5)
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
				}
				Spacer()
			}
			.frame(maxWidth: .infinity,maxHeight: 150)
			.background(Color.chewGrayScale15)
			.cornerRadius(10)
			HStack {
				DatePicker(
					"",
					selection: $date,
					displayedComponents: [.date]
				)
				// ".graphical" because it gives you info about current day,
				// ".wheels" you dont understand which day is now
				.datePickerStyle(.graphical)
				.padding(7)
				.cornerRadius(10)
				.padding(EdgeInsets(top: 0, leading: 0, bottom:0, trailing: 15))
				.background(Color.chewGrayScale15)
				.cornerRadius(10)
			}
			.frame(maxWidth: .infinity,maxHeight: 350)
			
			Spacer()
			Button(action: {
				if let dateCombined =  DateParcer.getCombinedDate(date: date, time: time) {
					chewVM.send(event: .onNewDate(.specificDate(dateCombined)))
				} else {
					print("DatePicker: DateParcer.getCombinedDate returned nil")
					chewVM.send(event: .onNewDate(.now))
				}
			}, label: {
				Text("Done")
					.padding(14)
					.chewTextSize(.big)
			})
			.frame(maxWidth: .infinity,minHeight: 43)
			.background(Color.chewGray10)
			.chewTextSize(.big)
			.foregroundColor(.primary)
			.cornerRadius(10)
		}
		.padding(10)
		.background(Color.chewGrayScale10)
	}
}
