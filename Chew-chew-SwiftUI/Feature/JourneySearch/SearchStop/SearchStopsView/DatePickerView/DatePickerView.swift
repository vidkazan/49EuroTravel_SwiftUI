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
	let setSheetType : (JourneySearchView.SheetType)->Void

	var body: some View {
		NavigationView {
			VStack(alignment: .center,spacing: 5) {
				ChewDatePicker(date: $time,mode: .time, style: .wheels)
					.frame(maxWidth: .infinity,maxHeight: 170)
					.padding(5)
				ChewDatePicker(date: $date,mode: .date, style: .inline)
					.scaleEffect(0.9)
					.frame(maxWidth: .infinity,maxHeight: 350)
					.padding(5)
					.background(Color.chewFillTertiary.opacity(0.15))
					.cornerRadius(10)
				DatePickerTimePresetButtons(setSheetType: setSheetType)
				Spacer()
			}
			.padding(.horizontal,10)
			.navigationTitle("Date Settings")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading, content: {
					Button(action: {
//						setSheetType(.none)
						chewVM.sheetViewModel.send(event: .didRequestHide)
					}, label: {
						Text("Cancel")
							.foregroundColor(.chewGray30)
					})
				})
				ToolbarItem(placement: .navigationBarTrailing, content: {
					Button(action: {
						if let dateCombined =  DateParcer.getCombinedDate(date: date, time: time) {
//							setSheetType(.none)
							chewVM.sheetViewModel.send(event: .didRequestHide)
							chewVM.send(event: .onNewDate(.specificDate(dateCombined.timeIntervalSince1970)))
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
