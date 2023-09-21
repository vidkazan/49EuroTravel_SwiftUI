//
//  JourneyHeaderView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 26.08.23.
//

import SwiftUI


struct JourneyHeaderView: View {
	let journey : JourneyCollectionViewData
	
    var body: some View {
		ZStack {
			HStack {
				TimeLabelView(
					isSmall: false,
					arragement: .right,
					planned: journey.startPlannedTimeDate,
					actual: journey.startActualTimeDate
				)
				.padding(7)
				Spacer()
				Text(journey.durationLabelText)
					.foregroundColor(.primary)
					.font(.system(size: 12,weight: .semibold))
				Spacer()
				TimeLabelView(isSmall: false, arragement: .left, planned: journey.endPlannedTimeDate, actual: journey.endActualTimeDate)
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
				startPlannedTimeDate: .now,
				startActualTimeDate: .now,
				endPlannedTimeDate: .now,
				endActualTimeDate: .now,
				startDate: .now,
				endDate: .now,
				durationLabelText: "11 h 11 min",
				legDTO: [],
				legs: [],
				sunEvents: [],
				isReachable: true,
				badges: [.dticket],
				refreshToken: ""
			)
		)
	}
}
