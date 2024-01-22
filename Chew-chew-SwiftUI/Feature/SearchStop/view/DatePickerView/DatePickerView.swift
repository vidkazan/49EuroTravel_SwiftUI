//
//  DatePickerView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 24.08.23.
//

import SwiftUI

struct ChewDatePicker: UIViewRepresentable {
	
	@Binding var date: Date
	let mode : UIDatePicker.Mode
	let style : UIDatePickerStyle

	func makeUIView(context: Context) -> UIDatePicker {
		let picker = UIDatePicker()

		picker.datePickerMode = mode
		picker.preferredDatePickerStyle = style
		picker.minuteInterval = 5
		picker.setDate(date, animated: true)
		picker.addTarget(context.coordinator, action: #selector(Coordinator.changed(_:)), for: .valueChanged)
		picker.locale = .init(identifier: "en_GB")
		return picker
	}

	func updateUIView(_ datePicker: UIDatePicker, context: Context) {
		datePicker.date = date
	}

	func makeCoordinator() -> ChewDatePicker.Coordinator {
		Coordinator(date: $date)
	}

	class Coordinator: NSObject {
		private let date: Binding<Date>

		init(date: Binding<Date>) {
			self.date = date
		}

		@objc func changed(_ sender: UIDatePicker) {
			self.date.wrappedValue = sender.date
		}
	}
}


struct DatePickerView: View {
	@EnvironmentObject private var chewVM : ChewViewModel
	@State var date : Date
	@State var time : Date
	var body: some View {
		NavigationView {
			VStack(alignment: .center,spacing: 5) {
				// MARK: time
				ChewDatePicker(date: $time,mode: .time, style: .wheels)
					.frame(maxWidth: .infinity,maxHeight: 150)
					.padding(5)
					.background(Color.chewFillTertiary.opacity(0.15))
					.cornerRadius(10)
				// MARK: date
				ChewDatePicker(date: $date,mode: .date, style: .inline)
					.frame(maxWidth: .infinity,maxHeight: 350)
					.padding(5)
					.background(Color.chewFillTertiary.opacity(0.15))
					.cornerRadius(10)
				DatePickerTimePresetButtons()
				Spacer()
			}
			.padding(.horizontal,10)
			.onDisappear {
				if let dateCombined =  DateParcer.getCombinedDate(date: date, time: time) {
					chewVM.send(event: .onNewDate(.specificDate(dateCombined)))
				}
			}
			.navigationTitle("Date Settings")
			.navigationBarTitleDisplayMode(.inline)
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


//struct DateSettingsPreview: PreviewProvider {
//	static var previews: some View {
//		DatePickerView(date: .now, time: .now)
//			.environmentObject(ChewViewModel())
//	}
//}
