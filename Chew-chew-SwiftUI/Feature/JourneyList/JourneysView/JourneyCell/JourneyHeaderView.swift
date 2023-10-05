//
//  JourneyHeaderView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 26.08.23.
//

import SwiftUI


struct JourneyHeaderView: View {
	let journey : JourneyViewData
	
    var body: some View {
		ZStack {
			HStack {
				TimeLabelView(
					isSmall: false,
					arragement: .right,
					planned: journey.timeContainer.stringValue.departure.planned ?? "time",
					actual: journey.timeContainer.stringValue.departure.actual ?? "time",
					delay: journey.timeContainer.departureDelay
				)
				.padding(7)
				Spacer()
				Text(journey.durationLabelText)
					.foregroundColor(.primary)
					.font(.system(size: 12,weight: .semibold))
				Spacer()
				TimeLabelView(
					isSmall: false,
					arragement: .left,
					planned: journey.timeContainer.stringValue.arrival.planned ?? "time",
					actual: journey.timeContainer.stringValue.arrival.actual ?? "time",
					delay: journey.timeContainer.arrivalDelay
				)
				.padding(7)
			}
			.frame(maxWidth: .infinity)
		}
		.frame(maxHeight: 40)
		.cornerRadius(10)
    }
}
