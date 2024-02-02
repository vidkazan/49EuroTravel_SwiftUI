//
//  LegDetailsView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 18.09.23.
//

import Foundation
import SwiftUI

struct LegStopView : View {
	@EnvironmentObject var chewVM : ChewViewModel
	@ObservedObject var vm : LegDetailsViewModel
	
	static let timeLabelColor = Color.chewTimeLabelGray
	let legViewData : LegViewData
	let stopOver : StopViewData
	let stopOverType : StopOverType
//	let now = Date.now.timeIntervalSince1970
	let showBadges : Bool
	
	
	var body : some View {
		switch stopOverType {
		case .transfer,.footMiddle:
			transfer
		case .footBottom:
			footBottom
		case .footTop,.origin,.destination,.stopover:
			HStack(alignment:  .top) {
				timeLabel
				nameAndBadges
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
		self.stopOver = stopOver
		self.stopOverType = type
		self.legViewData = leg
		self.vm = vm
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
		   let viewData = constructLegData(
			leg: mock,
			firstTS: .now,
			lastTS: .now,
			legs: [mock]
		   ) {
			ScrollView(.horizontal) {
				LazyHStack {
					ForEach(viewData.legStopsViewData.prefix(2)) { leg in
						VStack {
							ForEach(StopOverType.allCases, id: \.rawValue, content: { type in
								LegStopView(
									type: type,
									vm: .init(leg: viewData),
									stopOver: leg,
									leg: viewData,
									showBadges: true
								)
								.environmentObject(
									ChewViewModel(
										referenceDate: .specificDate((
											viewData.timeContainer.timestamp.departure.actual ?? 0))))
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
