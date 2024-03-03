//
//  SettingsView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 25.10.23.
//

import Foundation
import SwiftUI

extension SettingsView {
	var connections : some View {
		Section(content: {
			Picker(
				selection: $showWithTransfers,
				content: {
					Label("Direct", systemImage: "arrow.up.right")
						.tag(0)
					Label("With transfers", systemImage: "arrow.2.circlepath")
						.tag(1)
				}, label: {
				})
			.pickerStyle(.inline)
		}, header: {
			Text("Connections")
		})
	}
}

extension SettingsView {
	var transferSegment : some View {
		Section(content: {
			Picker(
				selection: $transferTime,
				content: {
					ForEach(ChewSettings.TransferDurationCases.allCases,id: \.rawValue) { val in
						Text("\(String(val.rawValue)) min ")
							.tag(val)
					}
				}, label: {
					Label("Minimum time", systemImage: "clock.arrow.circlepath")
				}
			)
			Picker(
				selection: $transferCount,
				content: {
					ForEach(ChewSettings.TransferCountCases.allCases,id: \.rawValue) { val in
						Text(val.rawValue)
							.tag(val)
					}
				}, label: {
					Label("Maximum count", systemImage: "arrow.2.squarepath")
				}
			)
		}, header: {
			Text("Transfer")
		})
	}
}

extension SettingsView {
	var debug : some View {
		Section(content: {
			Toggle(
				isOn: Binding(
					get: { alternativeSearchPage },
					set: { _ in alternativeSearchPage.toggle()}
				),
				label: {
					Text("Show alternative search page")
				}
			)
//			Toggle(
//				isOn: Binding(
//					get: { showSunEvents },
//					set: { _ in showSunEvents.toggle()}
//				),
//				label: {
//					Text("Show sun events")
//				}
//			)
			Button("Map picker view", action: {
				Model.shared.sheetViewModel.send(event: .didRequestShow(.mapPicker(type: .departure)))
			})
		}, header: {
			Text("Debug options")
		})
	}
}
