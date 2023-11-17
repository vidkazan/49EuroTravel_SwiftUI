//
//  DatePickerTimePresetButtons.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 29.08.23.
//

import SwiftUI

struct DatePickerTimePresetButtons: View {
	@EnvironmentObject var chewVM : ChewViewModel
	@Environment(\.managedObjectContext) var viewContext
	var body: some View {
		Button(action: {
			chewVM.send(event: .onNewDate(.now))
			ChewUser.updateWith(date: .now, using: viewContext, user: chewVM.user)
		}, label: {
			Text("now")
				.padding(14)
				.chewTextSize(.big)
		})
		.foregroundColor(.primary)
		.cornerRadius(10)
		Button(action: {
			let date = Date.now + (15 * 60)
			chewVM.send(event: .onNewDate(.specificDate(date)))
			ChewUser.updateWith(date: date, using: viewContext, user: chewVM.user)
		}, label: {
			Text("in 15 min")
				.padding(14)
				.chewTextSize(.big)
		})
		.foregroundColor(.primary)
		.cornerRadius(10)
		Button(action: {
			let date = Date.now + (60 * 60)
			chewVM.send(event: .onNewDate(.specificDate(date)))
			ChewUser.updateWith(date: date, using: viewContext, user: chewVM.user)
		}, label: {
			Text("in 1 hour")
				.padding(14)
				.chewTextSize(.big)
		})
		.foregroundColor(.primary)
		.cornerRadius(10)
	}
}
