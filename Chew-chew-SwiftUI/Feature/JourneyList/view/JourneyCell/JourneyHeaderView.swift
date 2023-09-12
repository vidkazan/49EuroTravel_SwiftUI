//
//  JourneyHeaderView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 26.08.23.
//

import SwiftUI
import CoreLocation

struct JourneyHeaderView: View {
	let journey : JourneyCollectionViewDataSourse
	var gradientStops : [Gradient.Stop]
	
	init(journey: JourneyCollectionViewDataSourse) {
		self.journey = journey
		let nightColor = Color.blue.opacity(0.5)
		let dayColor = Color.yellow.opacity(0.6)

		self.gradientStops = {
			var stops : [Gradient.Stop] = []
			for event in journey.sunEvents {
				switch event.type {
				case .sunrise:
					stops.append(.init(
						color: nightColor,
						location: (event.timeStart.timeIntervalSince1970 - journey.startDate.timeIntervalSince1970) / (journey.endDate.timeIntervalSince1970 - journey.startDate.timeIntervalSince1970)
					))
					if let final = event.timeFinal {
						stops.append(.init(
							color: dayColor,
							location: (final.timeIntervalSince1970 - journey.startDate.timeIntervalSince1970) / (journey.endDate.timeIntervalSince1970 - journey.startDate.timeIntervalSince1970)
						))
					}
				case .day:
					stops.append(.init(
						color: dayColor,
						location: 0
					))
				case .sunset:
					stops.append(.init(
						color: dayColor,
						location: (event.timeStart.timeIntervalSince1970 - journey.startDate.timeIntervalSince1970) / (journey.endDate.timeIntervalSince1970 - journey.startDate.timeIntervalSince1970)
					))
					if let final = event.timeFinal {
						stops.append(.init(
							color: nightColor,
							location:  (final.timeIntervalSince1970 - journey.startDate.timeIntervalSince1970) / (journey.endDate.timeIntervalSince1970 - journey.startDate.timeIntervalSince1970)
						))
					}
				case .night:
					stops.append(.init(
						color: nightColor,
						location: 0
					))
				}
			}
			
			return stops
		}()
	}
    var body: some View {
		ZStack {
			HStack{
				HStack{
					Text(journey.startActualTimeLabelText.isEmpty ? journey.startPlannedTimeLabelText : journey.startActualTimeLabelText)
						.foregroundColor(
							journey.startActualTimeLabelText.isEmpty ? .primary.opacity(0.85) : Color(hue: 0, saturation: 1, brightness: 0.8))
						.padding(EdgeInsets(top: 7, leading: 7, bottom: 7, trailing: 0))
						.font(.system(size: 17,weight: .semibold))
					Text(journey.startActualTimeLabelText.isEmpty ? "" : journey.startPlannedTimeLabelText)
						.strikethrough()
						.foregroundColor(.secondary)
						.font(.system(size: 12,weight: .semibold))
						.offset(x:-4)
					Spacer()
				}
				.frame(maxWidth: 200)
				Spacer()
				Text(journey.durationLabelText)
					.foregroundColor(.primary)
					.font(.system(size: 12,weight: .semibold))
				Spacer()
				HStack {
					Spacer()
					Text(journey.endActualTimeLabelText.isEmpty ? "" : journey.endPlannedTimeLabelText)
						.strikethrough()
						.foregroundColor(.secondary)
						.font(.system(size: 12,weight: .semibold))
						.offset(x:4)
					Text(journey.endActualTimeLabelText.isEmpty ? journey.endPlannedTimeLabelText : journey.endActualTimeLabelText)
						.foregroundColor(journey.endActualTimeLabelText.isEmpty ? .primary.opacity(0.85) : Color(hue: 0, saturation: 1, brightness: 0.8))
						.padding(EdgeInsets(top: 7, leading: 0, bottom: 7, trailing: 7))
						.font(.system(size: 17,weight: .semibold))
				}
				.frame(maxWidth: 200)
			}
//			.background(LinearGradient(
//					stops: gradientStops,
//					startPoint: UnitPoint(x: 0, y: 0),
//					endPoint: UnitPoint(x: 1, y: 0)).opacity(0.25))
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
				legs: [],
				sunEvents: [],
				isReachable: true
			)
		)
	}
}
