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
				self.bgColor = Color.chewFillTertiary.opacity(0.5)
			case .line,.transfer:
				self.bgColor = Color.chewFillTertiary.opacity(0.8)
			}
		case false:
			self.bgColor =  Color.chewRedScale20
		}
	}
	
	var body: some View {
		GeometryReader { geo in
			ZStack {
				RoundedRectangle(cornerRadius: 8)
					.fill(bgColor)
					.overlay {
						switch leg.legType {
						case .footStart,.footMiddle,.footEnd:
							HStack(spacing: 1) {
								let duration = "\(leg.duration)"
								if (geo.size.width > 15) {
									Image(.figureWalkCircle)
										.font(.system(size: 12))
										.foregroundColor(.primary)
								}
								if (Int(geo.size.width / 4) - 15 > duration.count) {
									Text(duration)
										.foregroundColor(.primary)
										.chewTextSize(.medium)
								}
							}
						case .line:
							if (Int(geo.size.width / 7) > leg.lineViewData.name.count) {
								Text(leg.lineViewData.name.replacingOccurrences(of: " ", with: ""))
									.foregroundColor(.primary)
									.chewTextSize(.medium)
							} else if (Int(geo.size.width / 7) > leg.lineViewData.shortName.count) {
								Text(leg.lineViewData.shortName)
									.foregroundColor(.primary)
									.chewTextSize(.medium)
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


struct LegViewLabels: View {
	var leg : LegViewData
	let screenWidth = UIScreen.main.bounds.width
	let bgColor : Color
	init(leg: LegViewData) {
		self.leg = leg
		switch leg.isReachable {
		case true:
			switch leg.legType {
			case .footMiddle,.footStart,.footEnd:
				self.bgColor = Color.chewFillTertiary.opacity(0.5)
			case .line,.transfer:
				self.bgColor = Color.chewFillTertiary.opacity(0.8)
			}
		case false:
			self.bgColor =  Color.chewRedScale20
		}
	}
	
	var body: some View {
		GeometryReader { geo in
			ZStack {
				RoundedRectangle(cornerRadius: 8)
					.fill(.clear)
					.overlay {
						switch leg.legType {
						case .footStart,.footMiddle,.footEnd:
							HStack(spacing: 1) {
								let duration = "\(leg.duration)"
								if (geo.size.width > 15) {
									Image(.figureWalkCircle)
										.font(.system(size: 12))
										.foregroundColor(.primary)
								}
								if (Int(geo.size.width / 4) - 15 > duration.count) {
									Text(duration)
										.foregroundColor(.primary)
										.chewTextSize(.medium)
								}
							}
						case .line:
							if (Int(geo.size.width / 7) > leg.lineViewData.name.count) {
								Text(leg.lineViewData.name.replacingOccurrences(of: " ", with: ""))
									.foregroundColor(.primary)
									.chewTextSize(.medium)
							} else if (Int(geo.size.width / 7) > leg.lineViewData.shortName.count) {
								Text(leg.lineViewData.shortName)
									.foregroundColor(.primary)
									.chewTextSize(.medium)
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


struct LegViewBG: View {
	var leg : LegViewData
	let screenWidth = UIScreen.main.bounds.width
	let bgColor : Color
	init(leg: LegViewData) {
		self.leg = leg
		switch leg.isReachable {
		case true:
			switch leg.legType {
			case .footMiddle,.footStart,.footEnd:
				self.bgColor = Color.chewFillTertiary.opacity(0.5)
			case .line,.transfer:
				self.bgColor = Color.chewFillSecondary.opacity(0.9)
			}
		case false:
			self.bgColor =  Color.chewFillRedPrimary.opacity(0.8)
		}
	}
	
	var body: some View {
		GeometryReader { geo in
			ZStack {
				RoundedRectangle(cornerRadius: 8)
					.fill(bgColor)
					.padding(.trailing,0.5)
			}
		}
	}
}
