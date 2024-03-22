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
					Label(
						title: {
							Text("Direct", comment : "SettingsView: connections: picker option")
						},
						icon: {
							Image(systemName: "arrow.up.right")
						}
					)
					.tag(0)
					Label(
						title: {
							Text("With transfers", comment : "SettingsView: connections: picker option")
						},
						icon: {
							Image(.arrowLeftArrowRight)
						}
					)
					.tag(1)
				}, label: {
				})
			.pickerStyle(.inline)
		}, header: {
			Text("Connections",comment: "SettingsView: connections: section header")
		})
	}
}

extension SettingsView {
	var transferSegment : some View {
		Section(content: {
			Picker(
				selection: $transferTime,
				content: {
					ForEach(JourneySettings.TransferDurationCases.allCases,id: \.rawValue) { val in
						Text(
							"\(val.rawValue) min ",
							comment: "SettingsView: transferSegment: transfer duration"
						)
						.tag(val)
					}
				}, label: {
					Label(
						title: {
							Text("Minimum time", comment : "SettingsView: transferSegment: picker name")
						},
						icon: {
							Image(systemName: "clock.arrow.circlepath")
						}
					)
				}
			)
			Picker(
				selection: $transferCount,
				content: {
					ForEach(JourneySettings.TransferCountCases.allCases,id: \.rawValue) { val in
						Text(verbatim: val.rawValue)
							.tag(val)
					}
				}, label: {
					Label(
						title: {
							Text("Maximum count", comment : "SettingsView: transferSegment: picker name")
						},
						icon: {
							Image(.arrowLeftArrowRight)
						}
					)
				}
			)
		}, header: {
			Text("Transfer",comment: "SettingsView: transferSegment: section header")
		})
	}
}

//extension SettingsView {
//	var debug : some View {
//		Section(content: {
//			Toggle(
//				isOn: Binding(
//					get: { alternativeSearchPage },
//					set: { _ in alternativeSearchPage.toggle()}
//				),
//				label: {
//					Text("Show alternative search page",comment: "SettingsView: debug: toggle")
//				}
//			)
//		}, header: {
//			Text("Debug options",comment: "SettingsView: debug: section header")
//		})
//	}
//}
