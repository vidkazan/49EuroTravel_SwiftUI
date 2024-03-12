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
	let mode : Settings.LegViewMode
	var journey : JourneyViewData?
	var gradientStops : [Gradient.Stop]
	var gradientStopsForProgressLine : [Gradient.Stop]
	var showProgressBar : Bool
	var showLabels : Bool
	@State var progressLineProportion : Double = 0
	
	init(journey: JourneyViewData?,progressBar: Bool, mode : Settings.LegViewMode,showLabels : Bool = true) {
		self.journey = journey
		self.showLabels = showLabels
		self.mode = mode
		self.showProgressBar = progressBar
		self.gradientStops = journey?.sunEventsGradientStops ?? []
		self.gradientStopsForProgressLine = gradientStops
	}
	
	var body: some View {
		VStack {
			VStack {
				GeometryReader { geo in
					ZStack {
						SunEventsGradient(
							gradientStops:  journey?.legs.allSatisfy({$0.isReachable == true}) == true ? gradientStops : nil,
							size: geo.size,
							mode : mode, 
							progressLineProportion: nil
						)
						if let journey = journey {
							ForEach(journey.legs) { leg in
								LegViewBG(leg: leg, mode: mode)
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
							RoundedRectangle(cornerRadius: 2)
								.fill(Color.chewFillGreenSecondary)
								.frame(
									width: progressLineProportion > 0 && progressLineProportion < 1 ? 3 : 0,
									height: 40
								)
								.position(
									x : geo.size.width * progressLineProportion,
									y : geo.size.height/2
								)
								.cornerRadius(5)
						}
						if let journey = journey, showLabels == true {
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
				.frame(height: 40)
			}
		}
		.onReceive(timer, perform: { _ in
			Task {
				withAnimation(.smooth, {
					self.progressLineProportion = Self.getProgressLineProportion(
						departureTS: journey?.time.timestamp.departure.actual,
						arrivalTS: journey?.time.timestamp.arrival.actual,
						referenceTimeTS: chewVM.referenceDate.date.timeIntervalSince1970)
				})
			}
		})
		.onAppear {
			Task {
				self.progressLineProportion = Self.getProgressLineProportion(
					departureTS: journey?.time.timestamp.departure.actual,
					arrivalTS: journey?.time.timestamp.arrival.actual,
					referenceTimeTS: chewVM.referenceDate.date.timeIntervalSince1970)
			}
		}
	}
}

struct LegViewSettingsView : View {
	let mode : Settings.LegViewMode
	let mock = Mock.journeys.journeyNeussWolfsburg.decodedData?.journey.journeyViewData(depStop: .init(), arrStop: .init(), realtimeDataUpdatedAt: 0)
	var body: some View {
		if let mock = mock {
			LegsView(
				journey: mock,
				progressBar: false,
				mode: mode,
				showLabels: false
			)
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
			Mock.journeys.journeyNeussWolfsburg.decodedData,
			Mock.journeys.journeyNeussWolfsburgFirstCancelled.decodedData
		]
		VStack {
			ForEach(mocks,id: \.?.realtimeDataUpdatedAt){ mock in
				if let mock = mock {
					let viewData = mock.journey.journeyViewData(
					   depStop: nil,
					   arrStop: nil,
					   realtimeDataUpdatedAt: 0
				   )
					LegsView(journey: viewData, progressBar: true,mode : .sunEvents)
						.environmentObject(ChewViewModel(
							referenceDate: .specificDate(
								(viewData?.time.timestamp.departure.actual ?? 0) + 2000
							))
						)
				}
			}
		}
		.padding()
	}
}
