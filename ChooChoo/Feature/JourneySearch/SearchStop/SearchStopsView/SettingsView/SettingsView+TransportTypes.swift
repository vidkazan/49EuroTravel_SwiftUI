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
				selection: $transportModeSegment,
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
						.tag(Settings.TransportMode.regional)
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
						.tag(Settings.TransportMode.all)
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
						.tag(Settings.TransportMode.custom)
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
