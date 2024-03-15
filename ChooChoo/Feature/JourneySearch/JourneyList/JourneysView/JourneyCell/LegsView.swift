//
//  LegsView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 25.08.23.
//

import SwiftUI

struct LegsView: View {
	@Namespace var legsViewNamespace
	@EnvironmentObject var chewVM : ChewViewModel
	@State var progressLineProportion : Double = 0
	
	let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
	let mode : Settings.LegViewMode
	let journey : JourneyViewData?
	var gradientStops : [Gradient.Stop]
	var showLabels : Bool
	let legTapAction : ((UUID)->())?
	
	init(
		journey: JourneyViewData?,
		mode : Settings.LegViewMode,
		showLabels : Bool = true,
		legTapAction : ((UUID)->())? = nil
	) {
		self.journey = journey
		self.showLabels = showLabels
		self.mode = mode
		self.gradientStops = journey?.sunEventsGradientStops ?? []
		self.legTapAction = legTapAction
	}
	
	var body: some View {
		VStack {
			GeometryReader { geo in
				ZStack {
					SunEventsGradient(
						gradientStops:  journey?.legs.allSatisfy({$0.isReachable == true}) == true ? gradientStops : nil,
						size: geo.size,
						mode : mode,
						progressLineProportion: nil
					)
					.matchedGeometryEffect(
						id: "sun",
						in: legsViewNamespace
					)
					if let journey = journey {
						ForEach(journey.legs) { leg in
							if let legTapAction = legTapAction {
								legViewBG(leg:leg,geo:geo)
								.onTapGesture {
									legTapAction(leg.id)
								}
							} else {
								legViewBG(leg:leg,geo:geo)
							}
						}
					}
//					if showProgressBar {
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
							.matchedGeometryEffect(
								id: "progressBar",
								in: legsViewNamespace
							)
//					}
					if let journey = journey, showLabels == true {
						ForEach(journey.legs) { leg in
							LegViewLabels(leg: leg)
								.matchedGeometryEffect(
									id: "\(leg.tripId) labels",
									in: legsViewNamespace
								)
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
		.onReceive(timer, perform: { _ in
			Task {
				withAnimation(.linear(duration: 1), {
					updateProgressLine()
				})
			}
		})
		.onAppear {
			Task {
				updateProgressLine()
			}
		}
	}
}

extension LegsView {
	func legViewBG(leg : LegViewData, geo : GeometryProxy) -> some View {
		LegViewBG(leg: leg, mode: mode)
			.matchedGeometryEffect(
				id: "\(leg.tripId) bg",
				in: legsViewNamespace
			)
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

extension LegsView {
	func updateProgressLine() {
		self.progressLineProportion = Self.getProgressLineProportion(
			departureTS: journey?.time.timestamp.departure.actual,
			arrivalTS: journey?.time.timestamp.arrival.actual,
			referenceTimeTS: chewVM.referenceDate.date.timeIntervalSince1970
		)
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
					LegsView(journey: viewData,mode : .sunEvents)
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
