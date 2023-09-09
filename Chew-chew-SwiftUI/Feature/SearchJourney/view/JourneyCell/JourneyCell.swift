//
//  JourneyCell.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//

import Foundation
import SwiftUI

struct JourneyCell: View {
	let journey : JourneyCollectionViewDataSourse
	init(journey: JourneyCollectionViewDataSourse) {
		self.journey = journey
	}
	
	var body: some View {
		VStack {
			JourneyHeaderView(journey: journey)
			LegsView(journey : journey)
			BadgesView(badges: [.dticket])
		}
			.id(journey.id)
			.background(.ultraThinMaterial)
			.cornerRadius(10)
			.padding(EdgeInsets(top: 0, leading: 5, bottom: 5, trailing: 5))
			.shadow(radius: 1,y:1)
			.frame(maxWidth: .infinity,maxHeight: 200)
	}
}

struct JourneyCell_Previews: PreviewProvider {
	static var previews: some View {
		VStack {
			JourneyCell(
				journey: .init(
					id: 0,
					startPlannedTimeLabelText: "11:11",
					startActualTimeLabelText: "11:12",
					endPlannedTimeLabelText: "22:22",
					endActualTimeLabelText: "22:23",
					startDate: .now,
					endDate: .now,
					durationLabelText: "11 h 11 min",
					legs: [],
					sunEvents: []
			))
		}
		.background(.blue)
	}
}
