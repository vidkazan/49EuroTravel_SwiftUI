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
		Button(action: {
			chewVM.send(event: .onNewDate(.now))
		}, label: {
			Text("now")
				.padding(14)
				.chewTextSize(.big)
		})
		.foregroundColor(.primary)
		.cornerRadius(10)
		Button(action: {
			chewVM.send(event: .onNewDate(.specificDate(Date.now + (15 * 60))))
		}, label: {
			Text("in 15 min")
				.padding(14)
				.chewTextSize(.big)
		})
		.foregroundColor(.primary)
		.cornerRadius(10)
		Button(action: {
			chewVM.send(event: .onNewDate(.specificDate(Date.now + (60 * 60))))
		}, label: {
			Text("in 1 hour")
				.padding(14)
				.chewTextSize(.big)
		})
		.foregroundColor(.primary)
		.cornerRadius(10)
	}
}
