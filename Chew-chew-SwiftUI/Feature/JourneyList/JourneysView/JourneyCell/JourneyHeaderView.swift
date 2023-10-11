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
					time : PrognoseType(
						actual: journey.timeContainer.stringValue.departure.actual ?? "time",
						planned:  journey.timeContainer.stringValue.departure.planned ?? "time"
					),
					delay: journey.timeContainer.departureDelay
				)
				.padding(7)
				Spacer()
				Text(journey.durationLabelText)
					.foregroundColor(.primary)
					.chewTextSize(.medium)
				Spacer()
				TimeLabelView(
					isSmall: false,
					arragement: .left,
					time : PrognoseType(
						actual: journey.timeContainer.stringValue.arrival.actual ?? "time",
						planned:  journey.timeContainer.stringValue.arrival.planned ?? "time"
					),
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
