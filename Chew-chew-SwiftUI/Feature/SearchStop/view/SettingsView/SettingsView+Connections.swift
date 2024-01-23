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
}
