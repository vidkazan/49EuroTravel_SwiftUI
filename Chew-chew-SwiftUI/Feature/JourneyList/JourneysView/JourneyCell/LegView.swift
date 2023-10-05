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
				.fill(leg.isReachable ? Color.chewGrayScale10.opacity(80) : Color.chewRedScale20)
				.cornerRadius(8)
				.overlay {
					switch leg.legType {
					case .footStart,.footMiddle,.footEnd:
						HStack(spacing: 1) {
							Image(systemName: "figure.walk.circle")
								.font(.system(size: 12))
								.foregroundColor(.primary)
							let duration = "\(leg.duration)"
							if (Int(geo.size.width / 3) - 15 > duration.count) {
								Text(duration)
									.foregroundColor(.primary)
									.font(.system(size: 12,weight: .semibold))
							}
						}
					case .line:
						if (Int(geo.size.width / 3) > leg.lineName.count) {
							Text(leg.lineName)
								.foregroundColor(.primary)
								.font(.system(size: 12,weight: .semibold))
						}
					case .transfer:
						EmptyView()
					}
				}
				.padding(.trailing,0.5)
		}
	}
}
