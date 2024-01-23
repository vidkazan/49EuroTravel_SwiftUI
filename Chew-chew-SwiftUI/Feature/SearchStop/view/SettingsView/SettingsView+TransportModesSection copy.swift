//
//  SettingsView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 25.10.23.
//

import Foundation
import SwiftUI

extension SettingsView {
	var segments : some View {
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
}
