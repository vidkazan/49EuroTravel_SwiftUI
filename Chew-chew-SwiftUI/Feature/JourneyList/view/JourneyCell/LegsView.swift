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
					.fill(.ultraThinMaterial.opacity(0.7))
					.frame(height:15)
					.cornerRadius(5)
				ForEach(journey.legs) { leg in
					LegView(leg: leg)
						.frame(
							width: geo.size.width * (leg.legBottomPosition - leg.legTopPosition),
							height:leg.delayedAndNextIsNotReachable == true ? 25 : 28)
						.position(x:geo.size.width * (leg.legTopPosition + (( leg.legBottomPosition - leg.legTopPosition ) / 2)),y: geo.size.height/2)
				}
			}
		}
		.frame(height:30)
		.padding(EdgeInsets(top: 5, leading: 7, bottom: 5, trailing: 7))
	}
}
