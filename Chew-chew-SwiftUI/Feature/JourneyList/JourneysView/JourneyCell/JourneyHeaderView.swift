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
					planned: journey.startPlannedTimeString,
					actual: journey.startActualTimeString,
					delay: journey.startDelay
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
					planned: journey.endPlannedTimeString,
					actual: journey.endActualTimeString,
					delay: journey.endDelay
				)
				.padding(7)
			}
			.frame(maxWidth: .infinity)
		}
		.frame(maxHeight: 40)
		.cornerRadius(10)
    }
}


struct Previews: PreviewProvider {
	static var previews: some View {
		JourneyHeaderView(
			journey: .init(
				id: UUID(),
				origin: "Origin",
				destination: "Destination",
				startPlannedTimeString: "11:11",
				startActualTimeString: "11:11",
				endPlannedTimeString: "22:22",
				endActualTimeString: "22:22",
				startDelay: 0,
				endDelay: 0,
				startDate: .now,
				endDate: .now,
				startDateString:  "21 sep 2023",
				endDateString: "21 sep 2023",
				durationLabelText: "11 h 11 min",
				legs: [], transferCount: 0,
				sunEvents: [],
				isReachable: true,
				badges: [.dticket],
				refreshToken: ""
			)
		)
	}
}
