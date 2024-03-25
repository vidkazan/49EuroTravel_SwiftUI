//
//  AppSettingsView.swift
//  ChooChoo
//
//  Created by Dmitrii Grigorev on 25.03.24.
//

import Foundation
import SwiftUI


struct AppSettingsView: View {
	@ObservedObject var appSetttingsVM : AppSettingsViewModel
	@State var settings : AppSettings
	init(appSetttingsVM: AppSettingsViewModel = Model.shared.appSettingsVM) {
		self.appSetttingsVM = appSetttingsVM
		self.settings = appSetttingsVM.state.settings
	}
	var body : some View {
		Form {
			Section(content: {
				Button(action: {
					appSetttingsVM.send(
						event: .didChangeLegViewMode(
							mode: settings.legViewMode.next()
						)
					)
				}, label: {
					LegViewSettingsView(mode: settings.legViewMode)
				})
			}, header: {
				Text("Leg appearance", comment: "settingsView: section name")
			})
		}
		.onReceive(appSetttingsVM.$state, perform: {
			settings = $0.settings
		})
	}
}
