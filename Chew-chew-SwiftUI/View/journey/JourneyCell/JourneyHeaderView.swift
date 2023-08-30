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
		let nightColor = Color(hue: 0.6, saturation: 1, brightness: 0.4)
		let dayColor = Color.yellow
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
							color: .yellow,
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
					.foregroundColor(.white)
					.frame(alignment: .leading)
			}
		}
		.cornerRadius(10)
    }
}

//struct JourneyHeaderView_Previews: PreviewProvider {
//    static var previews: some View {
//		JourneyHeaderView(journey: .init(
//			id: 0,
//			startTimeLabelText: "22:22",
//			endTimeLabelText: "11:11",
//			durationLabelText: "00:00",
//			legs: [], sunEvents: [])
//		)
//		.frame(height: 30)
//    }
//}
