//
//  LegDetailsView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 18.09.23.
//

import Foundation
import SwiftUI
import CoreLocation
import MapKit

struct LegDetailsView: View {
	@EnvironmentObject var chewVM : ChewViewModel
	@State var isExpanded : Segments.EvalType = .collapsed
	@State var totalProgressHeight : Double = 0
	@State var currentProgressHeight : Double = 0
	let leg : LegViewData
	let openSheet : (JourneyDetailsView.SheetType, LegViewData) -> Void
	let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
	let followedJourney : Bool
	let sendToJourneyVM : ((JourneyDetailsViewModel.Event)->Void)?
		
	init(
		followedJourney: Bool = false,
		send : @escaping (JourneyDetailsViewModel.Event) -> Void,
		referenceDate : ChewDate,
		openSheet : @escaping (JourneyDetailsView.SheetType,LegViewData) -> Void,
		isExpanded : Segments.EvalType,
		leg : LegViewData
	) {
		self.openSheet = openSheet
		self.leg = leg
		self.followedJourney = followedJourney
		self.sendToJourneyVM = send
		self.isExpanded = isExpanded
	}
	
	var body : some View {
		VStack {
			VStack(spacing: 0) {
				// MARK: Stop foot + transfer
				switch leg.legType {
				case .transfer,.footMiddle,.footStart:
					if let stop = leg.legStopsViewData.first {
						LegStopView(
							type: stop.stopOverType,
							stopOver: stop,
							leg: leg,
							showBadges : !followedJourney,
							shevronIsExpanded: isExpanded
						)
					}
				case .footEnd:
					if let stop = leg.legStopsViewData.last {
						LegStopView(
							stopOver: stop,
							leg: leg,
							showBadges : !followedJourney,
							shevronIsExpanded: isExpanded
						)
						.padding(.bottom,10)
					}
				// MARK: Stop line
				case .line:
					let stops : [StopViewData] = {
						switch isExpanded {
						case .expanded:
							return leg.legStopsViewData
						case .collapsed:
							if let first = leg.legStopsViewData.first,
								let last = leg.legStopsViewData.last {
									return [first,last]
								}
							return []
						}
					}()
					ForEach(stops) { stop in
						LegStopView(
							stopOver: stop,
							leg: leg,
							showBadges : !followedJourney,
							shevronIsExpanded: isExpanded
						)
					}
				}
			}
			.background { background }
		}
		// MARK: 🤢
		.padding(.top,leg.legType == LegViewData.LegType.line || leg.legType.caseDescription == "footStart" ?  10 : 0)
		.background(leg.legType == LegViewData.LegType.line ? Color.chewFillAccent : .clear )
		.overlay(alignment: .topTrailing) {
			Menu(content: {
				Button(action: {
					openSheet(.map,leg)
				}, label: {
					Label("Show on map", systemImage: "map.circle")
				})
				Button(action: {
					openSheet(.fullLeg,leg)
				}, label: {
					Label("Show full segment", systemImage: ChewSFSymbols.trainSideFrontCar.rawValue)
				})
			}, label: {
				Image(systemName: "ellipsis.circle")
					.chewTextSize(.big)
					.frame(minWidth: 43,minHeight: 43)
					.tint(Color.primary)
			})
		}
		.cornerRadius(10)
		.onAppear {
			updateProgressHeight()
		}
		.onReceive(timer, perform: { _ in
			updateProgressHeight()
		})
		.onChange(of: isExpanded, perform: { _ in
			updateProgressHeight()
		})
		.onTapGesture {
			isExpanded = {
				switch isExpanded {
				case .collapsed:
					return .expanded
				case .expanded:
					return .collapsed
				}
			}()
		}
	}
}

extension LegDetailsView {
	func updateProgressHeight(){
		self.currentProgressHeight = leg.progressSegments.evaluate(
			time: chewVM.referenceDate.ts ,
			type: isExpanded
		)
		self.totalProgressHeight = leg.progressSegments.heightTotal(isExpanded)
	}
}

@available(iOS 16.0, *)
struct LegDetailsPreview : PreviewProvider {
	static var previews : some View {
		let mocks = [
//			Mock.trip.cancelledFirstStopRE11DussKassel.decodedData?.trip,
//			Mock.trip.cancelledMiddleStopsRE6NeussMinden.decodedData?.trip,
			Mock.trip.cancelledLastStopRE11DussKassel.decodedData?.trip
		]
		let mock = Mock.journeys.journeyNeussWolfsburg.decodedData
		if let mock = mock?.journey {
			ScrollView {
				FlowLayout {
					ForEach(mock.legs, content: { leg in
						if let viewData = constructLegData(
							leg: leg,
							firstTS: .now,
							lastTS: .now,
							legs: mock.legs
						) {
							LegDetailsView(
								send: {_ in },
								referenceDate: .specificDate((viewData.time.timestamp.departure.planned ?? 0) + 900),
								openSheet: {_,_ in},
								isExpanded: .collapsed,
								leg: viewData
							)
							.environmentObject(ChewViewModel(referenceDate: .specificDate((viewData.time.timestamp.departure.planned ?? 0) + 900)))
							.frame(minWidth: 350)
						}
					})
					ForEach(mocks,id: \.?.id) { mock in
						if let viewData = constructLegData(
							leg: mock!,
							firstTS: .now,
							lastTS: .now,
							legs: [mock!]
						) {
							LegDetailsView(
								send: {_ in },
								referenceDate: .specificDate((viewData.time.timestamp.departure.planned ?? 0) + 900),
								openSheet: {_,_ in}, isExpanded: .collapsed,
								leg: viewData
							)
							.environmentObject(ChewViewModel(referenceDate: .specificDate((viewData.time.timestamp.departure.planned ?? 0) + 900)))
							.frame(minWidth: 350)
						}
					}
				}
			}
			.padding(5)
//			.previewDevice(PreviewDevice(.iPadMini6gen))
			.background(Color.chewFillPrimary)
//			.previewInterfaceOrientation(.landscapeLeft)
		} else {
			Text("error")
		}
	}
}
