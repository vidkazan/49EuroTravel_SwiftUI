//
//  SettingsView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 25.10.23.
//

import Foundation
import SwiftUI

struct SettingsView: View {
	@ObservedObject var chewVM : ChewViewModel
	@State var transportModeSegment : Int = 0
	@State var allTypes : Set<LineType> = Set(LineType.allCases)
	@State var selectedTypes : Set<LineType> = Set(LineType.allCases)
	init(vm : ChewViewModel) {
		self.chewVM = vm
	}
	var columns: [GridItem] = [
			GridItem(.adaptive(minimum: 110), spacing: 10),
			GridItem(.adaptive(minimum: 110), spacing: 10),
			GridItem(.adaptive(minimum: 110), spacing: 10)
	]
	var body: some View {
		VStack(alignment: .center) {
			Label("Settings", systemImage: "gearshape")
				.chewTextSize(.big)
			transportModesSection
//			Section(content: {
//
//			}, header: {
//
//			})
			Spacer()
			Button(action: {
				let transportMode = {
					switch self.transportModeSegment {
					case 1:
						return ChewSettings.TransportMode.deutschlandTicket
					case 0:
						return ChewSettings.TransportMode.all
					case 2:
						return ChewSettings.TransportMode.custom(types: selectedTypes)
					default:
					 	return ChewSettings.TransportMode.all
					}
				}()
				let res = ChewSettings(
					transportMode: transportMode,
					transferTime: .time(minutes: 0),
					accessiblity: .partial,
					walkingSpeed: .fast,
					language: .english,
					debugSettings: ChewSettings.ChewDebugSettings(prettyJSON: false),
					startWithWalking: true,
					withBicycle: false
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
		.onAppear {
			self.transportModeSegment = chewVM.state.settings.transportMode.id
			self.selectedTypes = {
				switch chewVM.state.settings.transportMode {
				case .deutschlandTicket:
					return Set(LineType.allCases)
				case .all:
					return Set(LineType.allCases)
				case .custom(types: let types):
					return types
				}
			}()
		}
		.padding(10)
		.background(Color.chewGrayScale10)
	}
	struct DTicketLabel: View {
		var body: some View {
			HStack {
				DTicketLogo()
					.chewTextSize(.medium)
				Text("D-ticket")
					.chewTextSize(.medium)
			}
		}
	}
}
