//
//  LegDetailsStopView+backgroung.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 30.01.24.
//

import Foundation
import SwiftUI

extension LegStopView {
	var timeLabelBackground : some View {
		LinearGradient(
			stops: [
				Gradient.Stop(color: Color.chewFillGreenPrimary, location: 0),
				Gradient.Stop(color: Color.chewFillGreenPrimary, location: stopOver.timeContainer.getStopCurrentTimePositionAlongActualDepartureAndArrival(currentTS: chewVM.referenceDate.ts) ?? 0),
				Gradient.Stop(color: LegStopView.timeLabelColor, location: stopOver.timeContainer.getStopCurrentTimePositionAlongActualDepartureAndArrival(currentTS: chewVM.referenceDate.ts) ?? 0)
			],
			startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 0, y: 1)
		)
	}
}
