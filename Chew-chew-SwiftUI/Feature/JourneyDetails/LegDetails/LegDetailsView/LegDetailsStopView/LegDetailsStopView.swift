//
//  LegDetailsView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 18.09.23.
//

import Foundation
import SwiftUI

struct LegStopView : View {
	static let timeLabelColor = Color.chewTimeLabelGray
	@ObservedObject var vm : LegDetailsViewModel
	let legViewData : LegViewData
	let stopOver : StopViewData
	let stopOverType : StopOverType
	let now = Date.now.timeIntervalSince1970
	let showBadges : Bool
	
	var body : some View {
		switch stopOverType {
		// MARK: .transfer,.footMiddle
		case .transfer,.footMiddle:
			HStack(alignment:  .center) {
				Rectangle()
					.fill(.clear)
					.frame(width: 70)
				VStack(alignment: .leading) {
					if stopOverType == .transfer {
						BadgeView(.transfer(duration: legViewData.duration))
					}
					if stopOverType == .footMiddle {
						BadgeView(.walking(duration: legViewData.duration))
					}
				}
				Spacer()
			}
			.frame(height: stopOverType.viewHeight)
		// MARK: .footBottom
		case .footBottom:
			HStack(alignment: .bottom) {
				VStack(alignment: .leading) {
					Spacer()
					TimeLabelView(stopOver : stopOver,stopOverType: stopOverType)
					.background { labelBackground }
					.cornerRadius(stopOverType.timeLabelCornerRadius)
					.shadow(radius: 2)
				}
				.frame(width: 70)
						// MARK: badges
				VStack(alignment: .leading, spacing: 2) {
					BadgeView(.walking(duration: legViewData.duration))
					Text(stopOver.name)
						.chewTextSize(.big)
				}
				Spacer()
			}
			.frame(height: stopOverType.viewHeight)
					// MARK: default
		case .footTop,.origin,.destination,.stopover:
			HStack(alignment:  .top) {
				VStack(alignment: .leading) {
					// MARK: timeLabel
					switch stopOverType {
					case .stopover:
						TimeLabelView(stopOver : stopOver,stopOverType: stopOverType)
						.background { labelBackground }
						.cornerRadius(stopOverType.timeLabelCornerRadius)
						.shadow(radius: 2)
						.offset(x: stopOver.timeContainer.departureStatus.value != nil ? stopOver.timeContainer.departureStatus.value! > 0 ? 8 : 0 : 0)
					case .origin, .footTop,.destination:
						TimeLabelView(stopOver : stopOver,stopOverType: stopOverType)
						.background { labelBackground }
						.cornerRadius(stopOverType.timeLabelCornerRadius)
						.shadow(radius: 2)
					case .footMiddle,.transfer,.footBottom:
						EmptyView()
					}
					Spacer()
				}
				.frame(width: 70)
				VStack(alignment: .leading, spacing: 2) {
					// MARK: stopName sup Badges
					switch stopOverType {
					case .origin, .destination,.footTop:
						Text(stopOver.name)
							.chewTextSize(.big)
					case .stopover:
						Text(stopOver.name)
							.chewTextSize(.medium)
							.foregroundColor(.gray)
					case .transfer,.footBottom,.footMiddle:
						EmptyView()
					}
					// MARK: badges
					switch stopOverType {
					case .footBottom,.footMiddle,.footTop:
						BadgeView(.walking(duration: legViewData.duration))
					case .origin,.destination:
						PlatformView(
							isShowingPlatormWord: true,
							platform: stopOver.departurePlatform.actual,
							plannedPlatform: stopOver.departurePlatform.planned
						)
						if showBadges == true, stopOverType == .origin { LegStopViewBadges }
					case .transfer:
						BadgeView(.transfer(duration: legViewData.duration))
					case .stopover:
						EmptyView()
					}
					// MARK: stopName sub Badges
					if case .footBottom = stopOverType{
						Text(stopOver.name)
							.chewTextSize(.big)
					}
				}
				Spacer()
			}
			.frame(height: stopOverType.viewHeight)
		}
	}
}

extension LegStopView {
	init(
		type : StopOverType,
		vm : LegDetailsViewModel,
		stopOver : StopViewData,
		leg : LegViewData,
		showBadges : Bool
	) {
		self.showBadges = showBadges
		self.vm = vm
		self.stopOver = stopOver
		self.stopOverType = type
		self.legViewData = leg
	}
	init(
		vm : LegDetailsViewModel,
		stopOver : StopViewData,
		leg : LegViewData,
		showBadges : Bool
	) {
		self.showBadges = showBadges
		self.vm = vm
		self.stopOver = stopOver
		self.stopOverType = stopOver.stopOverType
		self.legViewData = leg
	}
}

struct LegDetailsStopPreview : PreviewProvider {
	static var previews : some View {
		let mock = Mock.trip.cancelledMiddleStopsRE6NeussMinden.decodedData
		if let mock = mock?.trip,
		   let viewData = constructLegData(leg: mock, firstTS: .now, lastTS: .now, legs: [mock]) {
			ScrollView(.horizontal) {
				LazyHStack {
					ForEach(viewData.legStopsViewData.prefix(2)) { leg in
						VStack {
							ForEach(StopOverType.allCases, id: \.rawValue, content: {type in
								LegStopView(
									type: type,
									vm: .init(leg: viewData),
									stopOver: leg,
									leg: viewData,
									showBadges: true
								)
								.background(Color.chewFillPrimary)
								.cornerRadius(8)
							})
						}
						.frame(minWidth: 350)
						.padding(5)
						.border(.gray)
					}
				}
			}
			.previewDevice(PreviewDevice(.iPadMini6gen))
			.previewInterfaceOrientation(.landscapeLeft)
		} else {
			Text("error")
		}
	}
}
