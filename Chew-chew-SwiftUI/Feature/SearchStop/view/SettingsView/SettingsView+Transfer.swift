//
//  SettingsView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 25.10.23.
//

import Foundation
import SwiftUI
extension SettingsView {

	var transferSettings: some View {
			Section(content: {
				VStack {
					Picker("Settings", selection: $showWithTransfers ){
						Text("direct")
//							.chewTextSize(.medium)
							.tag(0)
						Text("with transfers")
//							.chewTextSize(.medium)
							.tag(1)
					}
					.pickerStyle(.segmented)
					.frame(height: 43)
					if showWithTransfers == 1 {
						HStack {
							Label("Transfer duration", systemImage: "clock.fill")
								.padding(.horizontal,10)
							Spacer()
							Picker("title", selection: $transferTime, content: {
								ForEach(arr,id:\.self) {
									Text("\(String($0)) min ")
										.tag($0)
								}
							})
							.padding(5)
							.pickerStyle(.automatic)
						}
						.padding(5)
					}
				}
				.background(Color.chewGray07)
				.cornerRadius(8)
			}, header: {
				HStack {
					Text("Connections")
					Spacer()
				}
			})
		}
	}
