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
			viewModel.updateJourneyTimeValue(date: Date.now)
			viewModel2.send(event: .onNewDate)
		}
			.padding(7)
			.foregroundColor(.primary)
			.cornerRadius(10)
			.padding(EdgeInsets(top: 7, leading: 7, bottom: 7, trailing: 0))
		Button("15 min") {
			viewModel.updateJourneyTimeValue(date: Date.now + (15 * 60))
			viewModel2.send(event: .onNewDate)
		}
			.padding(7)
			.foregroundColor(.primary)
			.cornerRadius(10)
			.padding(EdgeInsets(top: 7, leading: 7, bottom: 7, trailing: 0))
		Button("1 hour") {
			viewModel.updateJourneyTimeValue(date: Date.now + (60 * 60))
			viewModel2.send(event: .onNewDate)
		}
			.padding(7)
			.foregroundColor(.primary)
			.cornerRadius(10)
			.padding(EdgeInsets(top: 7, leading: 7, bottom: 7, trailing: 0))
    }
}
