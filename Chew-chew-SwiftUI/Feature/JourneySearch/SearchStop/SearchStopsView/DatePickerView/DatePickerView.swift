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
//	@State private var type : LocationDirectionType = .departure
	let closeSheet : ()->Void

	var body: some View {
		NavigationView {
			VStack(alignment: .center,spacing: 5) {
//				Picker("", selection: $type) {
//					Text("departure").tag(0)
//					Text("arrial").tag(1)
//				}
//				.pickerStyle(.segmented)
				ChewDatePicker(date: $time,mode: .time, style: .wheels)
					.frame(maxWidth: .infinity,maxHeight: 170)
					.padding(5)
				ChewDatePicker(date: $date,mode: .date, style: .inline)
					.scaleEffect(0.9)
					.frame(maxWidth: .infinity,maxHeight: 350)
					.padding(5)
					.background(Color.chewFillTertiary.opacity(0.15))
					.cornerRadius(10)
				DatePickerTimePresetButtons(closeSheet: closeSheet)
				Spacer()
			}
			.padding(.horizontal,10)
			.navigationTitle("Date Settings")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading, content: {
					Button(action: {
						closeSheet()
					}, label: {
						Text("Cancel")
							.foregroundColor(.chewGray30)
					})
				})
				ToolbarItem(placement: .navigationBarTrailing, content: {
					Button(action: {
						if let dateCombined =  DateParcer.getCombinedDate(date: date, time: time) {
							chewVM.send(event: .onNewDate(.specificDate(dateCombined.timeIntervalSince1970)))
							closeSheet()
						}
					}, label: {
						Text("Save")
							.chewTextSize(.big)
							.frame(maxWidth: 100,maxHeight: 43)
					})
				}
			)}
		}
	}
}
