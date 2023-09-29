//
//  DatePickerView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 24.08.23.
//

import SwiftUI

struct DatePickerView: View {
	@EnvironmentObject private var chewVM : ChewViewModel
	@State private var date = Date()
	@State private var time = Date()
	var startDate : Date
	init(startDat: Date = Date()) {
		startDate = startDat
	}
    var body: some View {
		VStack {
			HStack {
				DatePickerTimePresetButtons()
				Divider()
					.frame(height: 30)
				DatePicker(
					"",
					selection: $time,
					displayedComponents: [.hourAndMinute]
				)
					.environment(\.locale,NSLocale(localeIdentifier: "en_GB") as Locale)
					.datePickerStyle(.compact)
					.cornerRadius(10)
					.padding(EdgeInsets(top: 7, leading: 0, bottom: 7, trailing: 7))
					.onAppear {
						time = startDate
					}
				Spacer()
			}
				.frame(maxWidth: .infinity,maxHeight: 50)
				.background(.ultraThinMaterial)
				.cornerRadius(10)
			DatePicker(
				"",
				selection: $date,
				displayedComponents: [.date]
			)
					.onAppear {
						  date = startDate
					}
					.frame(minHeight: 400,alignment: .top)
					.datePickerStyle(.graphical)
					.padding(7)
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
		.font(.system(size: 17,weight: .semibold))
		.padding(5)
		.background(.ultraThinMaterial)
		.cornerRadius(10)
		.padding(5)
		.transition(.move(edge: .bottom))
		.opacity(chewVM.state.status == .datePicker ? 1 : 0)
		.animation(.spring(), value: chewVM.state.status)
	}
}
