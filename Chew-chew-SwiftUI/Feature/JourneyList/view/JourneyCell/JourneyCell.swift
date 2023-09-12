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
		ZStack {
			VStack {
				JourneyHeaderView(journey: journey)
				LegsView(journey : journey)
				BadgesView(badges: [.dticket])
			}
			.frame(maxWidth: .infinity,maxHeight: 400)
			.id(journey.id)
			.background(.ultraThinMaterial.opacity(0.5))
			.overlay {
				if !journey.isReachable {
					Color(hue: 0, saturation: 0.4, brightness: 0.1,opacity: 0.6).blendMode(.lighten)
				}
			}
			.cornerRadius(10)
		}
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
					durationLabelText: "11 h 11 min",
					legs: [],
					sunEvents: [],
					isReachable: false
			))
			.frame(maxHeight: 130)
			Spacer()
		}
		.background(.black)
	}
}
