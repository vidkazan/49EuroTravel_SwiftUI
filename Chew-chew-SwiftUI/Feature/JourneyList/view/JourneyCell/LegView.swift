//
//  LegView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 25.08.23.
//

import SwiftUI

struct LegView: View {
	var leg : LegViewData
	let screenWidth = UIScreen.main.bounds.width
	
	init(leg: LegViewData) {
		self.leg = leg
	}
	
	var body: some View {
		GeometryReader { geo in
			Rectangle()
				.fill(leg.fillColor)
				.cornerRadius(8)
				.overlay {
					if case .foot = leg.legType {
						HStack(spacing: 1) {
							Image(systemName: "figure.walk.circle")
								.font(.system(size: 12))
								.foregroundColor(.primary)
							if (Int(geo.size.width / 3) > leg.legType.value.count) {
								Text(leg.legType.value)
									.foregroundColor(.primary)
									.font(.system(size: 12,weight: .semibold))
							} else {
								Text("")
							}
						}
					} else {
						if (Int(geo.size.width / 3) > leg.legType.value.count) {
							Text(leg.legType.value)
								.foregroundColor(.primary)
								.font(.system(size: 12,weight: .semibold))
						} else {
							Text("")
						}
					}
				}
				.padding(.trailing,0.5)
		}
	}
}
