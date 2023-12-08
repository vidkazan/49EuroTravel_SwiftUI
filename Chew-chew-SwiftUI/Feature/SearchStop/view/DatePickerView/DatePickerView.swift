//
//  DatePickerView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 24.08.23.
//

import SwiftUI

struct DatePickerView: View {
	@EnvironmentObject private var chewVM : ChewViewModel
	@Environment(\.managedObjectContext) var viewContext
	@State var date : Date
	@State var time : Date
	var body: some View {
		Label("Date settings", systemImage: "clock")
			.padding(.top)
			.chewTextSize(.big)
		Form {
			
		}
		
		VStack(alignment: .center,spacing: 5) {
				// MARK: header buttons
				DatePickerTimePresetButtons()
				// MARK: time
				HStack {
					HStack {
						
						DatePicker(
							"",
							selection: $time,
							displayedComponents: [.hourAndMinute]
						)
						.environment(\.locale,NSLocale(localeIdentifier: "en_GB") as Locale)
						.frame(maxWidth: .infinity,maxHeight: 150)
						.scaleEffect(0.85)
						.datePickerStyle(.wheel)
						.cornerRadius(10)
						.padding(EdgeInsets(top: 0, leading: 7, bottom: 0, trailing: 15))
						Spacer()
					}
					.background(Color.chewFillAccent)
					.cornerRadius(10)
				}
				// MARK: header date
				HStack {
					DatePicker(
						"",
						selection: $date,
						displayedComponents: [.date]
					)
					.datePickerStyle(.graphical)
					.scaleEffect(0.9)
					.padding(5)
					.cornerRadius(10)
					.padding(EdgeInsets(top: 0, leading: 0, bottom:0, trailing: 15))
					.background(Color.chewFillAccent)
					.cornerRadius(10)
				}
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
						.chewTextSize(.big)
						.frame(maxWidth: .infinity,minHeight: 43)
				})
				.background(Color.chewFillAccent)
				.chewTextSize(.big)
				.foregroundColor(.primary)
				.cornerRadius(10)
			}
			.padding(5)
			.background(Color.chewFillPrimary)
			.onAppear {
				UIDatePicker.appearance().minuteInterval = 5
			}
		}
}
//
//struct ContentView_Previews: PreviewProvider {
//
//	static var previews: some View {
//		DatePickerView(date: .now, time: .now)
//	}
//}
