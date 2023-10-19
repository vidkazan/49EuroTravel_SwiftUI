//
//  DatePickerTimePresetButtons.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 29.08.23.
//

import SwiftUI

struct DatePickerTimePresetButtons: View {
	@EnvironmentObject var viewModel : SearchStopsViewModel
	@EnvironmentObject var chewVM : ChewViewModel
	var body: some View {
		Button("now") {
			chewVM.send(event: .onNewDate(.now))
		}
		.padding(7)
		.foregroundColor(.primary)
		.cornerRadius(10)
		.padding(7)
		Button("in 15 min") {
			chewVM.send(event: .onNewDate(.specificDate(Date.now + (15 * 60))))
		}
		.padding(7)
		.foregroundColor(.primary)
		.cornerRadius(10)
		.padding(7)
		Button("in 1 hour") {
			chewVM.send(event: .onNewDate(.specificDate(Date.now + (60 * 60))))
		}
		.padding(7)
		.foregroundColor(.primary)
		.cornerRadius(10)
		.padding(7)
	}
}
