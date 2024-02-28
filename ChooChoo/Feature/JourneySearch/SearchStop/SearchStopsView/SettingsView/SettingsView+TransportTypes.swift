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
					Label("Regional", image: "re")
						.tag(ChewSettings.TransportMode.regional.id)
					Label("All", image: "ice")
						.tag(ChewSettings.TransportMode.all.id)
					Label("Specific", systemImage: "pencil")
						.tag(ChewSettings.TransportMode.custom.id)
				},
				label: {}
			)
			.pickerStyle(.inline)
		}, header: {
			Text("Transport types")
		})
	}
}
