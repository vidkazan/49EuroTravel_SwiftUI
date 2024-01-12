//
//  DatePickerView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 24.08.23.
//

import SwiftUI

struct DatePickerView: View {
	@EnvironmentObject private var chewVM : ChewViewModel
	@State var date : Date
	@State var time : Date
	var body: some View {
		NavigationView {
			VStack(alignment: .center,spacing: 5) {
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
					.background(Color.chewFillTertiary.opacity(0.15))
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
					.padding(EdgeInsets(top: 0, leading: 0, bottom:0, trailing: 15))
					.background(Color.chewFillTertiary.opacity(0.15))
					.cornerRadius(10)
				}
				// MARK: header buttons
				DatePickerTimePresetButtons()
				Spacer()
			}
			.padding(.horizontal,10)
//			.background(Color.chewFillPrimary)
			.onAppear {
				UIDatePicker.appearance().minuteInterval = 5
			}
			.onDisappear {
				if let dateCombined =  DateParcer.getCombinedDate(date: date, time: time) {
					chewVM.send(event: .onNewDate(.specificDate(dateCombined)))
				}
			}
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading, content: {
					Button(action: {
						chewVM.send(event: .didDismissBottomSheet)
					}, label: {
						Text("Cancel")
							.foregroundColor(.chewGray30)
					})
				})
				ToolbarItem(placement: .navigationBarTrailing, content: {
					Button(action: {
						if let dateCombined =  DateParcer.getCombinedDate(date: date, time: time) {
							chewVM.send(event: .onNewDate(.specificDate(dateCombined)))
						}
					}, label: {
						Text("Done")
							.chewTextSize(.big)
							.frame(maxWidth: 100,maxHeight: 43)
					})
				}
			)}
		}
	}
}
