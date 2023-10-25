//
//  SettingsView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 25.10.23.
//

import Foundation
import SwiftUI

struct SettingsView: View {
	@EnvironmentObject private var chewVM : ChewViewModel
	var settings : ChewSettings
	@State var transportMode : ChewSettings.TransportMode
	var body: some View {
		VStack(alignment: .center) {
			List {
				Picker("Settings", selection: $transportMode, content: {
					DTicketLabel().tag(ChewSettings.TransportMode.deutschlandTicket)
						.chewTextSize(.medium)
					Text("all").tag(ChewSettings.TransportMode.all)
						.chewTextSize(.medium)
				})
				.pickerStyle(.segmented)
				.frame(maxWidth: .infinity,minHeight: 43)
			}
			.cornerRadius(10)
			Spacer()
			Button(action: {
				let res = ChewSettings(
					transportMode: transportMode,
					transferTime: settings.transferTime,
					accessiblity: settings.accessiblity,
					walkingSpeed: settings.walkingSpeed,
					language: settings.language,
					debugSettings: settings.debugSettings,
					startWithWalking: settings.startWithWalking,
					withBicycle: settings.withBicycle
				)
				chewVM.send(event: .didUpdateSettings(res))
			}, label: {
				Text("Save")
					.padding(14)
					.chewTextSize(.big)
			})
			.frame(maxWidth: .infinity,minHeight: 43)
			.background(Color.chewGray10)
			.chewTextSize(.big)
			.foregroundColor(.primary)
			.cornerRadius(10)
		}
		.padding(10)
		.background(Color.chewGrayScale10)
	}
}


extension SettingsView {
	struct DTicketLabel: View {
		var body: some View {
			HStack {
				DTicketLogo()
					.chewTextSize(.medium)
					.padding(4)
				Text("Deutschlandticket")
					.chewTextSize(.medium)
			}
		}
	}
}
