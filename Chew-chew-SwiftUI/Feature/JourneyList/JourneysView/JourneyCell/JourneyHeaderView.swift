//
//  JourneyHeaderView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 26.08.23.
//

import SwiftUI


struct JourneyHeaderView: View {
	let journey : JourneyViewData?
	
	var body: some View {
		ZStack {
			HStack {
				TimeLabelView(
					isSmall: false,
					arragement: .right,
					time : PrognosedTime(
						actual: journey?.timeContainer.stringTimeValue.departure.actual ?? "time",
						planned:  journey?.timeContainer.stringTimeValue.departure.planned ?? "time"
					),
					delay: journey?.timeContainer.departureStatus.value,
					isCancelled: false
				)
				.padding(7)
				Spacer()
				Text(journey?.durationLabelText ?? "duraton")
					.foregroundColor(.primary)
					.chewTextSize(.medium)
				Spacer()
				TimeLabelView(
					isSmall: false,
					arragement: .left,
					time : PrognosedTime(
						actual: journey?.timeContainer.stringTimeValue.arrival.actual ?? "time",
						planned:  journey?.timeContainer.stringTimeValue.arrival.planned ?? "time"
					),
					delay: journey?.timeContainer.arrivalStatus.value,
					isCancelled: false
				)
				.padding(7)
			}
			.frame(maxWidth: .infinity)
		}
		.frame(maxHeight: 40)
		.cornerRadius(10)
	}
}
