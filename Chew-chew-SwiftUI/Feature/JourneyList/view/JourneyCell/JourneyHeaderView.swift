//
//  JourneyHeaderView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 26.08.23.
//

import SwiftUI
import CoreLocation

struct TimeLabelView: View {
	let isSmall : Bool
	let isLeft : Bool
	var planned : String
	var actual : String
	
	init(isSmall: Bool, isLeft: Bool, planned: Date, actual: Date) {
		self.isSmall = isSmall
		self.isLeft = isLeft
		self.planned = DateParcer.getTimeStringFromDate(date:planned)
		self.actual = DateParcer.getTimeStringFromDate(date:actual)
	}
	
	var body: some View {
		HStack(spacing: 2){
			switch isLeft {
			case true:
				if !isSmall {
					actualTime()
				}
				plannedTime()
			case false:
				plannedTime()
				if !isSmall {
					actualTime()
				}
			}
		}
	}
}

extension TimeLabelView {
	func actualTime() -> some View {
		Text(actual == planned ? "" : planned)
			.strikethrough()
			.foregroundColor(.secondary)
			.font(.system(size: 12,weight: .semibold))
	}
	func plannedTime() -> some View {
		Text(actual == planned ? planned : actual)
			.foregroundColor(
				actual == planned ? .primary.opacity(0.85) : Color(hue: 0, saturation: 1, brightness: 0.8))
			.font(.system(size: isSmall == false ? 17 : 12,weight: isSmall == false ? .semibold : .regular))
	}
}

struct JourneyHeaderView: View {
	let journey : JourneyCollectionViewDataSourse
	
    var body: some View {
		ZStack {
			HStack{
				TimeLabelView(isSmall: false, isLeft: false, planned: journey.startPlannedTimeDate, actual: journey.startActualTimeDate)
				.padding(7)
				Spacer()
				Text(journey.durationLabelText)
					.foregroundColor(.primary)
					.font(.system(size: 12,weight: .semibold))
				Spacer()
				TimeLabelView(isSmall: false, isLeft: true, planned: journey.endPlannedTimeDate, actual: journey.endActualTimeDate)
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
