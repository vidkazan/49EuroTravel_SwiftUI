//
//  DatePickerView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 24.08.23.
//

import SwiftUI

// TODO: load it quiker
struct DatePickerView: View {
	@EnvironmentObject private var chewVM : ChewViewModel
	@Environment(\.managedObjectContext) var viewContext
	@State var date : Date
	@State var time : Date
	var body: some View {
		VStack(alignment: .center,spacing: 0) {
			
			
			// MARK: header buttons
			HStack {
				DatePickerTimePresetButtons()
			}
			.frame(maxWidth: .infinity,maxHeight: 50)
			.background(Color.chewGrayScale15)
			.cornerRadius(10)
			.padding(.bottom,7)
			
			
			// MARK: time
			HStack {
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
				.frame(maxWidth: .infinity,maxHeight: 130)
				.padding(.vertical,5)
				.background(Color.chewGrayScale15)
				.cornerRadius(10)
			}
			.padding(.bottom,15)
			
			// MARK: header date
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
			.frame(maxWidth: .infinity,maxHeight: 330)
			.padding(.bottom,5)
			
			
			Spacer()
			
			
			// MARK: done button
			Button(action: {
				if let dateCombined =  DateParcer.getCombinedDate(date: date, time: time) {
					chewVM.send(event: .onNewDate(.specificDate(dateCombined)))
					ChewUser.updateWith(date: dateCombined, using: viewContext, user: chewVM.user)
				} else {
					print("DatePicker: DateParcer.getCombinedDate returned nil")
					chewVM.send(event: .onNewDate(.now))
					ChewUser.updateWith(date: .now, using: viewContext, user: chewVM.user)
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
//
//struct ContentView_Previews: PreviewProvider {
//
//	static var previews: some View {
//		DatePickerView(date: .now, time: .now)
//	}
//}
