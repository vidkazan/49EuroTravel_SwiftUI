//
//  SettingsView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 25.10.23.
//

import Foundation
import SwiftUI

struct SettingsView: View {
	@EnvironmentObject  var chewViewModel : ChewViewModel
	
	let arr = [0,5,7,10,15,20,30,45,60,90,120]
	@State var transportModeSegment : Int
	let allTypes : [LineType] = LineType.allCases
	@State var selectedTypes = Set<LineType>()
	@State var transferTime : Int
	@State var showWithTransfers : Int
	let oldSettings : ChewSettings
	init(
		settings : ChewSettings
	) {
		self.oldSettings = settings
		self.transportModeSegment = settings.transportMode.id
		self.selectedTypes = settings.customTransferModes
		
		switch settings.transferTime {
		case .direct:
			self.showWithTransfers = 0
			self.transferTime = 0
		case .time(minutes: let minutes):
			self.showWithTransfers = 1
			self.transferTime = minutes
		}
	}
	var body: some View {
		NavigationView {
			//		Label("Settings", systemImage: "gearshape")
			//			.padding(.top)
			//			.chewTextSize(.big)
			Form {
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
				
				if transportModeSegment == 2 {
					Section(
						content: {
							ForEach(allTypes, id: \.id) { type in
								Toggle(
									isOn: Binding(
										get: {
											selectedTypes.contains(type)
										},
										set: { _ in
											selectedTypes.toogle(val: type)
										}
									),
									label: {
										Text(type.shortValue)
									}
								)
							}
						},
						header: {
							Text("Chosen transport types")
						})
				}
				// MARK: transfer settings
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
					if showWithTransfers == 1 {
						Picker(
							selection: $transferTime,
							content: {
								ForEach(arr.indices,id: \.self) { index in
									Text("\(String(arr[index])) min ")
										.tag(index)
								}
							}, label: {
								
							}
						)
						.pickerStyle(.wheel)
						.frame(idealHeight: 100)
					}
				}, header: {
					Text("Connections")
				})
			}
			.onChange(of: chewViewModel.state, perform: { state in
				let settings = state.settings
				self.transportModeSegment = settings.transportMode.id
				self.selectedTypes = settings.customTransferModes
				
				switch settings.transferTime {
				case .direct:
					self.showWithTransfers = 0
					self.transferTime = 0
				case .time(minutes: let minutes):
					self.showWithTransfers = 1
					self.transferTime = minutes
				}
			})
			.onDisappear {
				saveSettings()
			}
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading, content: {
					Button(action: {
						chewViewModel.send(event: .didDismissBottomSheet)
					}, label: {
						Text("Cancel")
							.foregroundColor(.chewGray30)
					})
				})
				ToolbarItem(placement: .navigationBarTrailing, content: {
					Button(action: {
						saveSettings()
					}, label: {
						Text("Done")
							.chewTextSize(.big)
							.frame(maxWidth: .infinity,minHeight: 35,maxHeight: 43)
					})
				}
			)}
		}
	}
	struct DTicketLabel: View {
		var body: some View {
			HStack {
				DTicketLogo(fontSize: 20)
					.padding(5)
					.background(Color.gray)
					.cornerRadius(8)
				Text("Deutschland ticket")
			}
		}
	}
}

extension SettingsView {
	private func saveSettings(){
		let transportMode = {
			switch self.transportModeSegment {
			case 1:
				return ChewSettings.TransportMode.deutschlandTicket
			case 0:
				return ChewSettings.TransportMode.all
			case 2:
				return ChewSettings.TransportMode.custom
			default:
				return ChewSettings.TransportMode.all
			}
		}()
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
			customTransferModes: selectedTypes,
			transportMode: transportMode,
			transferTime: transfer,
			accessiblity: .partial,
			walkingSpeed: .fast,
			language: .english,
			debugSettings: ChewSettings.ChewDebugSettings(prettyJSON: false),
			startWithWalking: true,
			withBicycle: false
		)
		chewViewModel.send(event: .didUpdateSettings(res))
		if res != oldSettings {
			chewViewModel.coreDataStore.updateSettings(
				newSettings: res
			)
		}
	}
}
