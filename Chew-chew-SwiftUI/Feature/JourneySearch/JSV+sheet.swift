//
//  ContentView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 23.08.23.
//

import SwiftUI

extension JourneySearchView {
	var sheet : some View {
		Group {
			switch sheetType {
			case .datePicker:
				if #available(iOS 16.0, *) {
					DatePickerView(
						date: chewViewModel.state.date.date,
						time: chewViewModel.state.date.date,
						closeSheet: {}
					)
					.presentationDetents([.height(300),.large])
				} else {
					DatePickerView(
						date: chewViewModel.state.date.date,
						time: chewViewModel.state.date.date,
						closeSheet: {}
					)
				}
			case .settings:
				SettingsView(
					settings: chewViewModel.state.settings,
					closeSheet: {}
				)
			case .none:
				EmptyView()
			}
		}
	}
}
