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
	let allTypes : [LineType] = LineType.allCases
	@State var selectedTypes = Set<LineType>()
	@State var transferTime : Int = 0
	@State var showWithTransfers : Int = 0
	init(vm : ChewViewModel) {
		self.chewVM = vm
	}
	var body: some View {
		Label("Settings", systemImage: "gearshape")
			.padding(.top)
			.chewTextSize(.big)
		NavigationView {
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
								.tag(ChewSettings.TransportMode.custom(types: Set(LineType.allCases)).id)
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
//										.background(selectedTypes.contains(type) ?
//													type.color.opacity(0.7) :
//														Color.chewGray10
//										)
//										.tint(selectedTypes.contains(type) ?
//											  Color.primary :
//												Color.secondary.opacity(0.7)
//										)
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
				}, header: {
					Text("Connections")
				})
				Section(content: {
					if showWithTransfers == 1 {
						Picker(
							selection: $transferTime,
							content: {
								ForEach(arr.indices,id: \.self) { index in
									Text("\(String(arr[index])) min ")
										.tag(index)
								}
						}, label: {
							Label("Transfer duration", systemImage: "clock.arrow.2.circlepath")
						})
					}
				}, header: {})
			}
			.frame(maxWidth: .infinity,maxHeight: .infinity)
			// MARK: save button
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
