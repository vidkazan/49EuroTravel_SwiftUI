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
	let planned : String
	let actual : String
	
	init(isSmall: Bool, isLeft: Bool, planned: String, actual: String) {
		self.isSmall = isSmall
		self.isLeft = isLeft
		self.planned = DateParcer.getTimeStringFromDate(
			date: DateParcer.getDateFromDateString(
				dateString: planned
			) ?? .now
		)
		self.actual = DateParcer.getTimeStringFromDate(
			date: DateParcer.getDateFromDateString(
				dateString: actual
			) ?? .now
		)
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
				TimeLabelView(isSmall: false, isLeft: false, planned: journey.startPlannedTimeLabelText, actual: journey.startActualTimeLabelText)
				.padding(7)
				Spacer()
				Text(journey.durationLabelText)
					.foregroundColor(.primary)
					.font(.system(size: 12,weight: .semibold))
				Spacer()
				TimeLabelView(isSmall: false, isLeft: true, planned: journey.endPlannedTimeLabelText, actual: journey.endActualTimeLabelText)
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
				startPlannedTimeLabelText: "11:11",
				startActualTimeLabelText: "11:12",
				endPlannedTimeLabelText: "22:23",
				endActualTimeLabelText: "22:22",
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
