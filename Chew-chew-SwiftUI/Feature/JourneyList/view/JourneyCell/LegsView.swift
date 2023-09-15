//
//  LegsView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 25.08.23.
//

import SwiftUI

struct LegsView: View {
	@EnvironmentObject var chewVM : ChewViewModel
	var journey : JourneyCollectionViewDataSourse
	var gradientStops : [Gradient.Stop]
	
	init(journey: JourneyCollectionViewDataSourse) {
		self.journey = journey
		
		let nightColor = Color(hue: 0.58, saturation: 1, brightness: 0.15)
		let dayColor = Color(hue: 0.12, saturation: 1, brightness: 0.7)

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
		VStack {
			GeometryReader { geo in
				ZStack {
					Rectangle()
						.overlay{
							LinearGradient(
								stops: gradientStops,
								startPoint: UnitPoint(x: 0, y: 0),
								endPoint: UnitPoint(x: 1, y: 0))
						}
						.frame(maxWidth: (geo.size.width - 6) > 0 ? geo.size.width - 6 : 0 ,maxHeight: 18)
						.cornerRadius(5)
					ForEach(journey.legs) { leg in
						LegView(leg: leg)
							.frame(
								width: geo.size.width * (leg.legBottomPosition - leg.legTopPosition),
								height:leg.delayedAndNextIsNotReachable == true ? 30 : 27)
							.position(x:geo.size.width * (leg.legTopPosition + (( leg.legBottomPosition - leg.legTopPosition ) / 2)),y: geo.size.height/2)
							.opacity(0.93)
					}
				}
			}
			.frame(height:25)
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
				.padding(4)
		}
		.padding(EdgeInsets(top: 0, leading: 7, bottom: 0, trailing: 7))
	}
}


