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
			.frame(height:25)
		}
	}
}

extension LegsView {
	static func getProgressLineProportion(departureTS : Double?, arrivalTS : Double?) -> CGFloat {
		guard let departureTS = departureTS, let arrivalTS = arrivalTS else {
			return 0
		}
		var prorportion = (Date.now.timeIntervalSince1970 - departureTS) / (arrivalTS - departureTS)
		prorportion = prorportion > 1 ? 1 : prorportion < 0 ? 0 : prorportion
		return prorportion
	}
}

struct SunEventsGradient : View {
	let gradientStops : [Gradient.Stop]
	let size : CGSize
	let isProgressLine : Bool
	let progressLineProportion : Double
	var body: some View {
		switch isProgressLine {
		case true:
			RoundedRectangle(cornerRadius: 5)
				.fill(Color.chewFillGreenPrimary.opacity(0.8))
				.frame(
					width: size.width * progressLineProportion,
					height: 30
				)
				.position(
					x : size.width * progressLineProportion / 2,
					y : size.height/2
				)
				.cornerRadius(5)
		case false:
			RoundedRectangle(cornerRadius: 5)
				.fill(.gray)
				.overlay{
					LinearGradient(
						stops: gradientStops,
						startPoint: UnitPoint(x: 0, y: 0),
						endPoint: UnitPoint(x: 1, y: 0))
				}
				.frame(
					maxWidth: size.width > 0 ? size.width - 1 : 0 ,
					maxHeight: 30
				)
				.cornerRadius(5)
		}
	}
}
