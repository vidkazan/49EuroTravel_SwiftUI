//
//  LegsView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 25.08.23.
//

import SwiftUI

struct LegsView: View {
	@EnvironmentObject var chewVM : ChewViewModel
	var journey : JourneyViewData?
	var gradientStops : [Gradient.Stop]
	
	init(journey: JourneyViewData?) {
		self.journey = journey
		
		let nightColor = Color.chewFillBluePrimary
		let dayColor = Color.chewFillYellowPrimary
		
		self.gradientStops = {
			var stops : [Gradient.Stop] = []
			guard let journey = journey else { return [] }
			for event in journey.sunEvents {
				if
					let startDateTS = journey.timeContainer.timestamp.departure.actual,
					let endDateTS = journey.timeContainer.timestamp.arrival.actual {
					switch event.type {
					case .sunrise:
						stops.append(Gradient.Stop(
							color: nightColor,
							location: (event.timeStart.timeIntervalSince1970 - startDateTS) / (endDateTS - startDateTS)
						))
						if let final = event.timeFinal {
							stops.append(Gradient.Stop(
								color: dayColor,
								location: (final.timeIntervalSince1970 - startDateTS) / (endDateTS - startDateTS)
							))
						}
					case .day:
						stops.append(Gradient.Stop(
							color: dayColor,
							location: 0
						))
					case .sunset:
						stops.append(Gradient.Stop(
							color: dayColor,
							location: (event.timeStart.timeIntervalSince1970 - startDateTS) / (endDateTS - startDateTS)
						))
						if let final = event.timeFinal {
							stops.append(Gradient.Stop(
								color: nightColor,
								location:  (final.timeIntervalSince1970 - startDateTS) / (endDateTS - startDateTS)
							))
						}
					case .night:
						stops.append(Gradient.Stop(
							color: nightColor,
							location: 0
						))
					}
				}
			}
			return stops
		}()
		
	}
	var body: some View {
		VStack {
			GeometryReader { geo in
				ZStack {
					RoundedRectangle(cornerRadius: 5)
						.fill(.gray)
						.overlay{
							LinearGradient(
								stops: gradientStops,
								startPoint: UnitPoint(x: 0, y: 0),
								endPoint: UnitPoint(x: 1, y: 0))
						}
						.frame(maxWidth: (geo.size.width) > 0 ? geo.size.width - 1 : 0 ,maxHeight: 18)
						.cornerRadius(5)
					if let journey = journey {
						ForEach(journey.legs) { leg in
							LegView(leg: leg)
								.frame(
									width: geo.size.width * (leg.legBottomPosition - leg.legTopPosition),
									height:leg.delayedAndNextIsNotReachable == true ? 30 : 27)
								.position(x:geo.size.width * (leg.legTopPosition + (( leg.legBottomPosition - leg.legTopPosition ) / 2)),y: geo.size.height/2)
								.opacity(0.90)
						}
					}
				}	
			}
			.frame(height:25)
		}
	}
}
