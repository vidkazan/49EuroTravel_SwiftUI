//
//  LegsView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 25.08.23.
//

import SwiftUI

struct LegsView: View {
	var journey : JourneyCollectionViewDataSourse
	init(journey: JourneyCollectionViewDataSourse) {
		self.journey = journey
	}
	var body: some View {
		GeometryReader { geo in
			ZStack {
				Rectangle()
					.fill(.ultraThinMaterial)
					.frame(height:15)
					.cornerRadius(5)
				ForEach(journey.legs) { leg in
					LegView(leg: leg)
						.frame(
							width: geo.size.width * (leg.legBottomPosition - leg.legTopPosition),
							height:leg.delayedAndNextIsNotReachable == true ? 23 : 25)
						.position(x:geo.size.width * (leg.legTopPosition + (( leg.legBottomPosition - leg.legTopPosition ) / 2)),y: geo.size.height/2)
				}
			}
		}
		.frame(height:30)
		.padding(EdgeInsets(top: 0, leading: 7, bottom: 0, trailing: 7))
	}
}
