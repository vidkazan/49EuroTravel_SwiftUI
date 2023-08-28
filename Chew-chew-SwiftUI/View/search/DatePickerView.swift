//
//  DatePickerView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 24.08.23.
//

import SwiftUI

struct DatePickerView: View {
	@EnvironmentObject var viewModel : SearchLocationViewModel
	
	@State private var date = Date()
	@State private var time = Date()
	var startDate : Date
	init(startDat: Date = Date()) {
		startDate = startDat
	}
    var body: some View {
		VStack {
			DatePicker(
				"",
				selection: $date,
				displayedComponents: [.date]
			)
			.onAppear {
				  date = startDate
			}
			.frame(minHeight: 400)
				.datePickerStyle(.graphical)
				.padding(7)
				.background(.thinMaterial)
				.cornerRadius(10)
			HStack {
				Button("now") {
					viewModel.updateJourneyTimeValue(date: Date.now)
				}
				.padding(7)
				.foregroundColor(.primary)
					.cornerRadius(10)
					.padding(EdgeInsets(top: 7, leading: 7, bottom: 7, trailing: 0))
				Button("15 min") {
					viewModel.updateJourneyTimeValue(date: Date.now + (15 * 60))
				}
				.padding(7)
				.foregroundColor(.primary)
					.cornerRadius(10)
					.padding(EdgeInsets(top: 7, leading: 7, bottom: 7, trailing: 0))
				Button("1 hour") {
					viewModel.updateJourneyTimeValue(date: Date.now + (60 * 60))
				}
				.padding(7)
				.foregroundColor(.primary)
					.cornerRadius(10)
					.padding(EdgeInsets(top: 7, leading: 7, bottom: 7, trailing: 0))
				Spacer()
				Divider()
					.padding(EdgeInsets(top: 0, leading: 7, bottom: 0, trailing: 0))
					.frame(height: 30)
				Spacer()
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
				.background(.thinMaterial)
				.cornerRadius(10)
			Spacer()
			Button("Done") {
				if let dateCombined =  DateParcer.getCombinedDate(date: date, time: time) {
					print(dateCombined)
					viewModel.updateJourneyTimeValue(date: dateCombined)
				}
			}
				.frame(maxWidth: .infinity,minHeight: 43)
				.background(.regularMaterial)
				.foregroundColor(Color.black)
				.cornerRadius(10)
			
		}
		.font(.system(size: 17,weight: .semibold))
		.padding(5)
		.background(.ultraThinMaterial)
		.cornerRadius(10)
		.padding(EdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 5))
		.opacity(viewModel.isShowingDatePicker ? 1 : 0)
		.transition(.move(edge: .bottom))
		.animation(.easeInOut, value: viewModel.isShowingDatePicker)
	}
}

//struct DatePickerView_Previews: PreviewProvider {
//    static var previews: some View {
//        DatePickerView(viewModel: viewModel)
//    }
//}


