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
		let nightColor = Color(hue: 0.57, saturation: 0.7, brightness: 0.9).opacity(0.8)
		let dayColor = Color(hue: 0.13, saturation: 0.6, brightness: 1).opacity(0.8)
		self.journey = journey
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
			LinearGradient(
				stops: gradientStops,
				startPoint: UnitPoint(x: 0, y: 0),
				endPoint: UnitPoint(x: 1, y: 0))
			.background(.ultraThinMaterial)
			HStack{
				Text(journey.startTimeLabelText)
					.padding(7)
					.font(.system(size: 17,weight: .semibold))
					.frame(alignment: .leading)
				Spacer()
				Text(journey.durationLabelText)
					.font(.system(size: 12))
					.padding(7)
					.frame(alignment: .center)
				Spacer()
				Text(journey.endTimeLabelText)
					.padding(7)
					.font(.system(size: 17,weight: .semibold))
					.frame(alignment: .leading)
			}
		}
		.cornerRadius(10)
    }
}
