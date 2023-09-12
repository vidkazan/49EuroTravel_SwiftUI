//
//  LegsView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 25.08.23.
//

import SwiftUI

struct LegsView: View {
	var journey : JourneyCollectionViewDataSourse
	var gradientStops : [Gradient.Stop]
	
	init(journey: JourneyCollectionViewDataSourse) {
		self.journey = journey
		
		let nightColor = Color(hue: 0.55, saturation: 1, brightness: 0.2)
		let dayColor = Color(hue: 0.15, saturation: 0.7, brightness: 0.7)

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
		GeometryReader { geo in
			ZStack {
				Rectangle()
//					.fill(.ultraThinMaterial.opacity(0.7))
					.frame(height:15)
					.background(LinearGradient(
							stops: gradientStops,
							startPoint: UnitPoint(x: 0, y: 0),
							endPoint: UnitPoint(x: 1, y: 0)).opacity(0.7))
					.cornerRadius(5)
				ForEach(journey.legs) { leg in
					LegView(leg: leg)
						.frame(
							width: geo.size.width * (leg.legBottomPosition - leg.legTopPosition),
							height:leg.delayedAndNextIsNotReachable == true ? 28 : 25)
						.position(x:geo.size.width * (leg.legTopPosition + (( leg.legBottomPosition - leg.legTopPosition ) / 2)),y: geo.size.height/2)
						.opacity(0.9)
				}
			}
		}
		.frame(height:30)
		.padding(EdgeInsets(top: 5, leading: 7, bottom: 5, trailing: 7))
	}
}
