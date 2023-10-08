//
//  DatePickerTimePresetButtons.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 29.08.23.
//

import SwiftUI

struct DatePickerTimePresetButtons: View {
	@EnvironmentObject var viewModel : SearchLocationViewModel
	@EnvironmentObject var chewVM : ChewViewModel
    var body: some View {
		Button("now") {
			chewVM.send(event: .onNewDate(.now))
		}
			.padding(7)
			.foregroundColor(.primary)
			.cornerRadius(10)
			.padding(EdgeInsets(top: 7, leading: 7, bottom: 7, trailing: 0))
		Button("in 15 min") {
			chewVM.send(event: .onNewDate(.specificDate(Date.now + (15 * 60))))
		}
			.padding(7)
			.foregroundColor(.primary)
			.cornerRadius(10)
			.padding(EdgeInsets(top: 7, leading: 7, bottom: 7, trailing: 0))
		Button("in 1 hour") {
			chewVM.send(event: .onNewDate(.specificDate(Date.now + (60 * 60))))
		}
			.padding(7)
			.foregroundColor(.primary)
			.cornerRadius(10)
			.padding(EdgeInsets(top: 7, leading: 7, bottom: 7, trailing: 0))
    }
}
