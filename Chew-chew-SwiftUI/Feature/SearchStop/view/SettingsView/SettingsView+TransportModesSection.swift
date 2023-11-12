//
//  SettingsView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 25.10.23.
//

import Foundation
import SwiftUI

extension SettingsView {
	var transportModesSection: some View {
			Section(content: {
				VStack {
					Picker("Settings", selection: $transportModeSegment ){
						DTicketLabel()
							.tag(ChewSettings.TransportMode.deutschlandTicket.id)
						Text("all")
							.tag(ChewSettings.TransportMode.all.id)
						Text("specific")
							.tag(ChewSettings.TransportMode.custom(types: Set(LineType.allCases)).id)
					}
					.pickerStyle(.segmented)
					.frame(height: 43)
					if transportModeSegment == 2 {
						LazyVGrid(
							columns: columns
						) {
							ForEach(allTypes.sorted(by: <), id: \.id) { type in
								Button(
									action: {
										selectedTypes.toogle(val: type)
									},
									label: {
										Text(type.shortValue)
											.frame(minWidth: 100,minHeight: 43)
											.padding(2)
											.background(selectedTypes.contains(type) ?
														type.color.opacity(0.7) :
															Color.chewGray10
											)
											.tint(selectedTypes.contains(type) ?
												  Color.primary :
													Color.secondary.opacity(0.7)
											)
											.cornerRadius(8)
									}
								)
							}
						}
						.padding(.bottom,5)
					}
				}
				.background(Color.chewGray10)
				.cornerRadius(8)
			}, header: {
				HStack {
					Text("Transport modes")
						.padding(1)
					Spacer()
				}
			})
		}
	}
