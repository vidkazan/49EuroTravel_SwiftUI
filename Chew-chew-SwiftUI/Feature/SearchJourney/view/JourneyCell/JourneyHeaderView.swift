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
		let nightColor = Color(hue: 0.57, saturation: 0.7, brightness: 0.8).opacity(0.8)
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
				Text(journey.startPlannedTimeLabelText)
					.foregroundColor(journey.startActualTimeLabelText == "" ? .black : .secondary )
					.padding(EdgeInsets(top: 7, leading: 7, bottom: 7, trailing: 0))
					.font(.system(size: 17,weight: .semibold))
					.frame(alignment: .leading)
				Text(journey.startActualTimeLabelText)
					.font(.system(size: 12,weight: .semibold))
					.frame(alignment: .topLeading)
					.offset(x:-3,y:-2)
					.foregroundColor(Color(hue: 0, saturation: 1, brightness: 0.7))
				Spacer()
				Text(journey.durationLabelText)
					.font(.system(size: 12))
					.frame(alignment: .center)
				Spacer()
				Text(journey.endActualTimeLabelText)
					.font(.system(size: 12,weight: .semibold))
					.frame(alignment: .topTrailing)
					.offset(x:3,y:-2)
					.foregroundColor(Color(hue: 0, saturation: 1, brightness: 0.7))
				Text(journey.endPlannedTimeLabelText)
					.foregroundColor(journey.endActualTimeLabelText == "" ? .black : .secondary )
					.padding(EdgeInsets(top: 7, leading: 0, bottom: 7, trailing: 7))
					.font(.system(size: 17,weight: .semibold))
					.frame(alignment: .trailing)
			}
		}
		.frame(maxHeight: 40)
		.cornerRadius(10)
    }
}


struct Previews: PreviewProvider {
	static var previews: some View {
		JourneyHeaderView(
			journey: .init(
				id: 0,
				startPlannedTimeLabelText: "11:11",
				startActualTimeLabelText: "11:12",
				endPlannedTimeLabelText: "22:23",
				endActualTimeLabelText: "22:22",
				startDate: .now,
				endDate: .now,
				durationLabelText: "11 h 11 min",
				legs: [],
				sunEvents: []
			)
		)
	}
}
