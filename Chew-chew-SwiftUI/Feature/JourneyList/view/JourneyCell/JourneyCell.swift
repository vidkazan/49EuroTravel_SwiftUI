//
//  JourneyCell.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//

import Foundation
import SwiftUI

struct JourneyCell: View {
	@EnvironmentObject var chewVM : ChewViewModel
	let journey : JourneyCollectionViewDataSourse
	init(journey: JourneyCollectionViewDataSourse) {
		self.journey = journey
	}
	
	var body: some View {
		VStack {
			JourneyHeaderView(journey: journey)
			LegsView(journey : journey)
			platformView()
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
	
	func platformView() -> some View {
		HStack {
			if let pl = journey.legDTO?.first?.departurePlatform {
				Text(pl)
					.foregroundColor(pl == journey.legDTO?.first?.plannedDeparturePlatform ? .primary : .red)
					.font(.system(size: 12,weight: .semibold))
					.padding(EdgeInsets(top: 2, leading: 6, bottom: 2, trailing: 6))
					.background(Color(red: 0.1255, green: 0.156, blue: 0.4))
			}
			Text(journey.legDTO?.first?.origin?.name != chewVM.topSearchFieldText ? journey.legDTO?.first?.origin?.name ?? "" : "")
				.font(.system(size: 12,weight: .semibold))
				.foregroundColor(.secondary)
			Spacer()
		}
		.padding(7)
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
