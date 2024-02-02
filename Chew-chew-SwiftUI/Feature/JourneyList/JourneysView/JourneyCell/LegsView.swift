//
//  LegsView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 25.08.23.
//

import SwiftUI

struct LegsView: View {
	@EnvironmentObject var chewVM : ChewViewModel
	let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
	var journey : JourneyViewData?
	var gradientStops : [Gradient.Stop]
	var gradientStopsForProgressLine : [Gradient.Stop]
	var showProgressBar : Bool
	@State var progressLineProportion : Double = 0
	
	init(journey: JourneyViewData?,progressBar: Bool) {
		self.journey = journey
		self.showProgressBar = progressBar
		self.gradientStops = journey?.sunEventsGradientStops ?? []
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
		.onReceive(timer, perform: { _ in
			self.progressLineProportion = Self.getProgressLineProportion(
				departureTS: journey?.timeContainer.timestamp.departure.actual,
				arrivalTS: journey?.timeContainer.timestamp.arrival.actual,
				referenceTimeTS: chewVM.referenceDate.date.timeIntervalSince1970)
		})
		.onAppear {
			self.progressLineProportion = Self.getProgressLineProportion(
				departureTS: journey?.timeContainer.timestamp.departure.actual,
				arrivalTS: journey?.timeContainer.timestamp.arrival.actual,
				referenceTimeTS: chewVM.referenceDate.date.timeIntervalSince1970)
		}
	}
}

extension LegsView {
	static func getProgressLineProportion(
		departureTS : Double?,
		arrivalTS : Double?,
		referenceTimeTS : Double = Date.now.timeIntervalSince1970
	) -> CGFloat {
		guard let departureTS = departureTS, let arrivalTS = arrivalTS else {
			return 0
		}
		var proportion = (referenceTimeTS - departureTS) / (arrivalTS - departureTS)
		proportion = proportion > 1 ? 1 : proportion < 0 ? 0 : proportion
		return proportion
	}
}

struct LegsViewPreviews: PreviewProvider {
	static var previews: some View {
		let mocks = [
			Mock.journeys.journeyNeussWolfsburgMissedConnection.decodedData,
			Mock.journeys.userLocationToStation.decodedData,
			Mock.journeys.journeyNeussWolfsburgFirstCancelled.decodedData
		]
		VStack {
			ForEach(mocks,id: \.?.realtimeDataUpdatedAt){ mock in
				if let mock = mock {
					let viewData = constructJourneyViewData(
						journey: mock.journey,
					   depStop: nil,
					   arrStop: nil,
					   realtimeDataUpdatedAt: 0
				   )
					LegsView(journey: viewData, progressBar: true)
						.environmentObject(ChewViewModel(
							referenceDate: .specificDate(
								(viewData?.timeContainer.timestamp.departure.actual ?? 0) + 2000
							))
						)
				}
			}
		}
		.padding()
	}
}
