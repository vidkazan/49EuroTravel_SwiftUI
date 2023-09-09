//
//  DatePickerView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 24.08.23.
//

import SwiftUI

struct DatePickerView: View {
	@EnvironmentObject private var viewModel2 : SearchJourneyViewModel
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
				.shadow(radius: 1,y:1)
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
					viewModel2.send(event: .onNewDate(dateCombined))
				} else {
					viewModel2.send(event: .onNewDate(.now))
				}
			}
				.frame(maxWidth: .infinity,minHeight: 43)
				.background(.regularMaterial)
				.foregroundColor(Color.black)
				.cornerRadius(10)
				.shadow(radius: 1,y:1)
		}
		.font(.system(size: 17,weight: .semibold))
		.padding(5)
		.background(.ultraThinMaterial)
		.cornerRadius(10)
		.padding(5)
		.shadow(radius: 1,y:1)
		.transition(.move(edge: .bottom))
		.opacity(viewModel2.state.status == .datePicker ? 1 : 0)
		.animation(.spring(), value: viewModel2.state.status)
	}
}