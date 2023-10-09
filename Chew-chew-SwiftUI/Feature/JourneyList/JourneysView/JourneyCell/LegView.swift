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
	let bgColor : Color
	init(leg: LegViewData) {
		self.leg = leg
		switch leg.isReachable {
		case true:
			switch leg.legType {
			case .footMiddle,.footStart,.footEnd:
				self.bgColor = Color.chewGrayScale20.opacity(90)
			case .line,.transfer:
				self.bgColor = Color.chewGrayScale15.opacity(90)
			}
		case false:
			self.bgColor =  Color.chewRedScale20
		}
	}
	
	var body: some View {
		GeometryReader { geo in
			ZStack {
				Rectangle()
					.fill(bgColor)
					.cornerRadius(8)
					.overlay {
						switch leg.legType {
						case .footStart,.footMiddle,.footEnd:
							HStack(spacing: 1) {
								let duration = "\(leg.duration)"
								if (geo.size.width > 15) {
									Image(systemName: "figure.walk.circle")
										.font(.system(size: 12))
										.foregroundColor(.primary)
								}
								if (Int(geo.size.width / 4) - 15 > duration.count) {
									Text(duration)
										.foregroundColor(.primary)
										.font(.system(size: 12,weight: .semibold))
								}
							}
						case .line:
							if (Int(geo.size.width / 7) > leg.lineViewData.name.count) {
								Text(leg.lineViewData.name)
									.foregroundColor(.primary)
									.font(.system(size: 12,weight: .semibold))
							} else if (Int(geo.size.width / 7) > leg.lineViewData.shortName.count) {
								Text(leg.lineViewData.shortName)
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
}
