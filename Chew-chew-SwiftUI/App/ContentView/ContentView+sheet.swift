//
//  ContentView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 23.08.23.
//

import SwiftUI

extension FeatureView {
	var sheet : some View {
		Group {
			switch chewViewModel.state.status {
			case .settings:
				SettingsView(settings: chewViewModel.state.settings)
			case .datePicker:
				DatePickerView(
					date: chewViewModel.state.timeChooserDate.date,
					time: chewViewModel.state.timeChooserDate.date
				)
			default:
				EmptyView()
			}
		}
	}
}
