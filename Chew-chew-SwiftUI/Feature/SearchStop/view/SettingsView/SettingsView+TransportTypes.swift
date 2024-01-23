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
					DTicketLabel()
						.tag(ChewSettings.TransportMode.deutschlandTicket.id)
					Label("All", systemImage: "train.side.front.car")
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
