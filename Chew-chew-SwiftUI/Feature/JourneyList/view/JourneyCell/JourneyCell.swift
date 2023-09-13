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
			BadgesView(badges: journey.badges)
		}
		.id(journey.id)
		.background(.ultraThinMaterial.opacity(0.5))
		.overlay {
			if !journey.isReachable {
				Color.black.opacity(0.7)
			}
		}
		.cornerRadius(10)
	}
}

struct JourneyCell_Previews: PreviewProvider {
	static var previews: some View {
		VStack {
			Spacer()
			JourneyCell(
				journey: .init(
					id: UUID(),
					startPlannedTimeLabelText: "11:11",
					startActualTimeLabelText: "11:12",
					endPlannedTimeLabelText: "22:22",
					endActualTimeLabelText: "22:23",
					startDate: .now,
					endDate: .now,
					durationLabelText: "11 h 11 min", legDTO: [],
					legs: [],
					sunEvents: [
						.init(
							type: .day,
							location: .init(latitude: 53, longitude: 6),
							timeStart: .now,
							timeFinal: .now
						)],
					isReachable: true,
					badges: [.dticket]
			))
			.frame(maxHeight: 130)
			Spacer()
		}
		.background(.black)
	}
}
