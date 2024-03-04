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
				ForEach(allTypes, id: \.rawValue) { type in
					if type != .foot, type != .transfer {
						Toggle(
							isOn: Binding(
								get: { selectedTypes.contains(type) },
								set: { _ in selectedTypes.toogle(val: type)}
							),
							label: {
								Text(type.shortValue)
							}
						)
					}
				}
			},
			header: {
				Text("Chosen transport types")
			})
	}
}