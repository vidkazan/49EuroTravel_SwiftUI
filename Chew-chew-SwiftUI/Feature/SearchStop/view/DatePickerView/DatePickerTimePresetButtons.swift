//
//  DatePickerTimePresetButtons.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 29.08.23.
//

import SwiftUI

struct DatePickerTimePresetButtons: View {
	@EnvironmentObject var chewVM : ChewViewModel
	var body: some View {
		HStack {
			Button(action: {
				chewVM.send(event: .onNewDate(.now))
			}, label: {
				Text("now")
					.padding(.horizontal,15)
					.frame(minHeight: 50)
					.chewTextSize(.big)
			})
			.foregroundColor(.primary)
			.cornerRadius(10)
			Button(action: {
				let date = Date.now + (15 * 60)
				chewVM.send(event: .onNewDate(.specificDate(date)))
			}, label: {
				Text("in 15 min")
					.padding(.horizontal,15)
					.frame(minHeight: 50)
					.chewTextSize(.big)
			})
			.foregroundColor(.primary)
			.cornerRadius(10)
			Button(action: {
				let date = Date.now + (60 * 60)
				chewVM.send(event: .onNewDate(.specificDate(date)))
			}, label: {
				Text("in 1 hour")
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
