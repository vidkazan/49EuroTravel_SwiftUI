//
//  DatePickerTimePresetButtons.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 29.08.23.
//

import SwiftUI

struct DatePickerTimePresetButtons: View {
	@EnvironmentObject var chewVM : ChewViewModel
	let closeSheet : ()->Void
	let mode : LocationDirectionType
	var body: some View {
		HStack {
			Button(action: {
				Task {
					chewVM.send(
						event: .didUpdateSearchData(
							date: SearchStopsDate(
								date: .now,
								mode: mode
							)
						)
					)
					closeSheet()
				}
			}, label: {
				Text("now",comment: "DatePickerTimePresetButtons")
					.padding(.horizontal,15)
					.frame(minHeight: 50)
					.chewTextSize(.big)
			})
			.foregroundColor(.primary)
			.cornerRadius(10)
			Button(action: {
				Task {
					let date = Date.now + (15 * 60)
					chewVM.send(
						event: .didUpdateSearchData(
							date: SearchStopsDate(
								date: .specificDate(date.timeIntervalSince1970),
								mode: mode
							)
						)
					)
					closeSheet()
				}
			}, label: {
				Text("in 15 min",comment: "DatePickerTimePresetButtons")
					.padding(.horizontal,15)
					.frame(minHeight: 50)
					.chewTextSize(.big)
			})
			.foregroundColor(.primary)
			.cornerRadius(10)
			Button(action: {
				Task {
					let date = Date.now + (60 * 60)
					chewVM.send(
						event: .didUpdateSearchData(
							date: SearchStopsDate(
								date: .specificDate(date.timeIntervalSince1970),
								mode: mode
							)
						)
					)
					closeSheet()
				}
			}, label: {
				Text("in 1 hour",comment: "DatePickerTimePresetButtons")
					.padding(.horizontal,15)
					.frame(minHeight: 50)
					.chewTextSize(.big)
			})
			.foregroundColor(.primary)
			.cornerRadius(10)
		}
		.frame(maxWidth: .infinity)
		.background(Color.chewFillTertiary.opacity(0.4))
		.cornerRadius(10)
	}
}
