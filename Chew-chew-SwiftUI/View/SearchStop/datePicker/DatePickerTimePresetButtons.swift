//
//  DatePickerTimePresetButtons.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 29.08.23.
//

import SwiftUI

struct DatePickerTimePresetButtons: View {
	@EnvironmentObject var viewModel : SearchLocationViewModel
	@EnvironmentObject var viewModel2 : SearchJourneyViewModel
    var body: some View {
		Button("now") {
			viewModel2.send(event: .onNewDate(.now))
		}
			.padding(7)
			.foregroundColor(.primary)
			.cornerRadius(10)
			.padding(EdgeInsets(top: 7, leading: 7, bottom: 7, trailing: 0))
		Button("15 min") {
			viewModel2.send(event: .onNewDate(Date.now + (15 * 60)))
		}
			.padding(7)
			.foregroundColor(.primary)
			.cornerRadius(10)
			.padding(EdgeInsets(top: 7, leading: 7, bottom: 7, trailing: 0))
		Button("1 hour") {
			viewModel2.send(event: .onNewDate(Date.now + (60 * 60)))
		}
			.padding(7)
			.foregroundColor(.primary)
			.cornerRadius(10)
			.padding(EdgeInsets(top: 7, leading: 7, bottom: 7, trailing: 0))
    }
}
