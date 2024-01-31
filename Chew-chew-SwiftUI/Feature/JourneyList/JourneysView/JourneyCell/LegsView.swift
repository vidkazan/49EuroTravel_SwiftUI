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
	var gradientStopsForProgressLine : [Gradient.Stop]
	var showProgressBar : Bool
	var progressLineProportion : Double
	
	init(journey: JourneyViewData?,progressBar: Bool) {
		self.journey = journey
		self.showProgressBar = progressBar
		self.gradientStops = journey?.sunEventsGradientStops ?? []
		self.progressLineProportion = Self.getProgressLineProportion(
			departureTS: journey?.timeContainer.timestamp.departure.actual,
			arrivalTS: journey?.timeContainer.timestamp.arrival.actual
		)
		self.gradientStopsForProgressLine = gradientStops
	}
	var body: some View {
		VStack {
			GeometryReader { geo in
				ZStack {
					SunEventsGradient(
						gradientStops: gradientStops,
						size: geo.size,
						isProgressLine: false,
						progressLineProportion: progressLineProportion
					)
					if let journey = journey {
						ForEach(journey.legs) { leg in
							LegViewBG(leg: leg)
							.frame(
								width: geo.size.width * (leg.legBottomPosition - leg.legTopPosition),
								height:leg.delayedAndNextIsNotReachable == true ? 40 : 35)
							.position(
								x : geo.size.width * (
									leg.legTopPosition + (
										( leg.legBottomPosition - leg.legTopPosition ) / 2
									)
								),
								y: geo.size.height/2
							)
							.opacity(0.90)
						}
					}
					if showProgressBar {
						SunEventsGradient(
							gradientStops: gradientStops,
							size: geo.size,
							isProgressLine: true,
							progressLineProportion: progressLineProportion
						)
					}
					if let journey = journey {
						ForEach(journey.legs) { leg in
							LegViewLabels(leg: leg)
								.frame(
									width: geo.size.width * (leg.legBottomPosition - leg.legTopPosition),
									height:leg.delayedAndNextIsNotReachable == true ? 40 : 35)
								.position(
									x : geo.size.width * (
										leg.legTopPosition + (
											( leg.legBottomPosition - leg.legTopPosition ) / 2
										)
									),
									y: geo.size.height/2
								)
								.opacity(0.90)
						}
					}
				}	
			}
			.frame(height:40)
		}
	}
}

extension LegsView {
	static func getProgressLineProportion(departureTS : Double?, arrivalTS : Double?) -> CGFloat {
		guard let departureTS = departureTS, let arrivalTS = arrivalTS else {
			return 0
		}
		var proportion = (Date.now.timeIntervalSince1970 - departureTS) / (arrivalTS - departureTS)
		proportion = proportion > 1 ? 1 : proportion < 0 ? 0 : proportion
		return proportion
	}
}

struct LegsViewPreviews: PreviewProvider {
	static var previews: some View {
		let mock = Mock.journeyList.journeyNeussWolfsburg.decodedData
		if let mock = mock {
			let viewData = constructJourneyListViewData(
				journeysData: mock,
				depStop: .init(),
				arrStop: .init()
			)
			VStack {
//				ForEach(viewData) { data in
//					LegsView(journey: data, progressBar: false)
//				}
				let mock = Mock.journeys.journeyNeussWolfsburgMissedConnection.decodedData
				if let mock = mock {
					let viewData = constructJourneyViewData(
						journey: mock.journey,
						depStop: nil,
						arrStop: nil,
						realtimeDataUpdatedAt: 0
					)
					LegsView(journey: viewData, progressBar: false)
				}
			}
		}
	}
}
