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
			HStack {
				Button("now") {
					viewModel.updateJourneyTimeValue(date: Date.now)
				}
				.padding(7)
				.foregroundColor(.primary)
					.cornerRadius(10)
					.padding(EdgeInsets(top: 7, leading: 7, bottom: 7, trailing: 0))
				Button("in 15 min") {
					viewModel.updateJourneyTimeValue(date: Date.now + (15 * 60))
				}
				.padding(7)
				.foregroundColor(.primary)
					.cornerRadius(10)
					.padding(EdgeInsets(top: 7, leading: 7, bottom: 7, trailing: 0))
				Button("in 1 hour") {
					viewModel.updateJourneyTimeValue(date: Date.now + (60 * 60))
				}
				.padding(7)
				.foregroundColor(.primary)
					.cornerRadius(10)
					.padding(EdgeInsets(top: 7, leading: 7, bottom: 7, trailing: 0))
				Divider()
					.padding(EdgeInsets(top: 0, leading: 7, bottom: 0, trailing: 0))
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
			}
				.frame(maxWidth: .infinity,maxHeight: 60)
				.background(.thinMaterial)
				.cornerRadius(10)
			DatePicker(
				"",
				selection: $date,
				displayedComponents: [.date]
			)
				.datePickerStyle(.graphical)
				.padding(7)
				.background(.thinMaterial)
				.cornerRadius(10)
			
			Button("Done") {
				if let dateCombined =  DateParcer.getCombinedDate(date: date, time: time) {
					print(dateCombined)
					viewModel.updateJourneyTimeValue(date: dateCombined)
				}
			}
				.frame(maxWidth: .infinity,minHeight: 43)
				.background(.regularMaterial)
				.foregroundColor(Color.blue)
				.cornerRadius(10)
			Spacer()
		}
		.font(.system(size: 17,weight: .semibold))
		.padding(5)
		.background(.ultraThinMaterial)
		.cornerRadius(10)
		.padding(EdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 5))
	}
}

struct DatePickerView_Previews: PreviewProvider {
    static var previews: some View {
        DatePickerView()
    }
}


