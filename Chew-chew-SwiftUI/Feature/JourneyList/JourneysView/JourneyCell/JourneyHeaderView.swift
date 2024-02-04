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
		HStack {
			TimeLabelView(
				size: .big,
				arragement: .right,
				time : journey.time.stringTimeValue.departure,
				delayStatus: journey.time.departureStatus
			)
			.padding(7)
			Spacer()
			TimeLabelView(
				size: .big,
				arragement: .left,
				time : journey.time.stringTimeValue.arrival,
				delayStatus: journey.time.arrivalStatus
			)
			.padding(7)
		}
		.overlay {
			Text(journey.durationLabelText)
				.foregroundColor(.primary)
				.chewTextSize(.medium)
		}
		.frame(maxWidth: .infinity,maxHeight: 40)
		.cornerRadius(10)
	}
}
