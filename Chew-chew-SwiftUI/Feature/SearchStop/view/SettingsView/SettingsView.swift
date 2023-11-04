//
//  SettingsView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 25.10.23.
//

import Foundation
import SwiftUI

struct SettingsView: View {
	let arr = [0,5,7,10,15,20,30,45,60,90,120]
	@ObservedObject var chewVM : ChewViewModel
	@State var transportModeSegment : Int = 0
	@State var allTypes : Set<LineType> = Set(LineType.allCases)
	@State var selectedTypes : Set<LineType> = Set(LineType.allCases)
	
	@State var transferTime : Int = 0
	@State var showWithTransfers : Int = 0
	init(vm : ChewViewModel) {
		self.chewVM = vm
		UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color.chewGray10)
		UISegmentedControl.appearance().backgroundColor = UIColor(Color(hue: 0, saturation: 0, brightness: 0.04))
		UISegmentedControl.appearance().layer.cornerRadius = 10
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
			ScrollView {
				transportModesSection
				transferSettings
				Spacer()
			}
			.frame(maxWidth: .infinity,maxHeight: .infinity)
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
//				print(showWithTransfers,transferTime)
				let transfer : ChewSettings.TransferTime =  {
					switch self.showWithTransfers {
					case 0:
						return ChewSettings.TransferTime.direct
					case 1:
						return ChewSettings.TransferTime.time(minutes: Int(self.transferTime))
					default:
						return ChewSettings.TransferTime.time(minutes: Int(self.transferTime))
					}
				}()
				
				let res = ChewSettings(
					transportMode: transportMode,
					transferTime: transfer,
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
			switch chewVM.state.settings.transferTime {
				case .direct:
					self.showWithTransfers = 0
					self.transferTime = 0
				case .time(let time):
					self.showWithTransfers = 1
					self.transferTime = time
			}
			
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
