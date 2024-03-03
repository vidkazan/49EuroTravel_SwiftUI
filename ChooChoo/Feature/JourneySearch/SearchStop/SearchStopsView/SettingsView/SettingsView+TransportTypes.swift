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
						.tag(ChewSettings.TransportMode.regional)
					Label("All", image: "ice")
						.tag(ChewSettings.TransportMode.all)
					Label("Custom", systemImage: "ellipsis")
						.tag(ChewSettings.TransportMode.custom)
				},
				label: {}
			)
			.pickerStyle(.inline)
		}, header: {
			Text("Transport types")
		})
	}
}
