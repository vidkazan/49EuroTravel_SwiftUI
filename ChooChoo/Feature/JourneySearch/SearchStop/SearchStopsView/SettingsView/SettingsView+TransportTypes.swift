//
//  SettingsView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 25.10.23.
//

import Foundation
import SwiftUI

extension SettingsView {
	var transportTypes : some View {
		Section(content: {
			Picker(
				selection: 
					Binding<JourneySettings.TransportMode>(
						get: {
							currentSettings.transportMode
						},
						set: {
							currentSettings.transportMode = $0
						}
					),
				content: {
					Label(
						title: {
							Text(
								"Regional",
								comment: "SettingsView: transportTypes: picker option"
							)
						},
						icon: {
							Image("re")
						}
					)
						.tag(JourneySettings.TransportMode.regional)
					Label(
						title: {
							Text(
								"All",
								comment: "SettingsView: transportTypes: picker option"
							)
						},
						icon: {
							Image("ice")
						}
					)
						.tag(JourneySettings.TransportMode.all)
					Label(
						title: {
							Text(
								"Custom",
								comment: "SettingsView: transportTypes: picker option"
							)
						},
						icon: {
							Image(systemName: "ellipsis")
						}
					)
						.tag(JourneySettings.TransportMode.custom)
				},
				label: {}
			)
			.pickerStyle(.inline)
		}, header: {
			Text(
				"Transport types",
				comment: "SettingsView: transportTypes: section header"
			)
		})
	}
}
