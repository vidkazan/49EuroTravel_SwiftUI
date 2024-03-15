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
	
	let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
	static let progressLineBaseWidth : CGFloat = 15
	static let progressLineCompletedBaseWidthOffset : CGFloat = 2
	
	@State var isExpandedState : Segments.EvalType = .collapsed
	@State var totalProgressHeight : Double = 0
	@State var currentProgressHeight : Double = 0
	
	let leg : LegViewData
	let isExpanded : Segments.EvalType
	let followedJourney : Bool
		
	init(
		followedJourney: Bool = false,
		send : @escaping (JourneyDetailsViewModel.Event) -> Void,
		referenceDate : ChewDate,
		isExpanded : Segments.EvalType,
		leg : LegViewData
	) {
		self.leg = leg
		self.followedJourney = followedJourney
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
							shevronIsExpanded: isExpandedState
						)
					}
				case .footEnd:
					if let stop = leg.legStopsViewData.last {
						LegStopView(
							stopOver: stop,
							leg: leg,
							showBadges : !followedJourney,
							shevronIsExpanded: isExpandedState
						)
						.padding(.bottom,10)
					}
				// MARK: Stop line
				case .line:
					let stops : [StopViewData] = {
						switch isExpandedState {
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
					ForEach(stops,id:\.name) { stop in
						LegStopView(
							stopOver: stop,
							leg: leg,
							showBadges : !followedJourney,
							shevronIsExpanded: isExpandedState
						)
					}
				}
			}
			.background { background }
		}
		// MARK: 🤢
		.padding(.top,leg.legType == LegViewData.LegType.line || leg.legType.caseDescription == "footStart" ?  10 : 0)
		.background(leg.legType == LegViewData.LegType.line ? Color.chewLegDetailsCellGray : .clear )
		.onTapGesture {
			withAnimation(.smooth, {
				switch isExpandedState {
				case .collapsed:
					isExpandedState = .expanded
				case .expanded:
					isExpandedState = .collapsed
				}
			})
		}
		.overlay(alignment: .topTrailing) { options }
		.cornerRadius(10)
		.onAppear {
			isExpandedState = isExpanded
			updateProgressHeight()
		}
		.onReceive(timer, perform: { _ in
			withAnimation(.smooth, {
				updateProgressHeight()
			})
		})
		.onChange(of: isExpandedState, perform: { _ in
			withAnimation(.smooth, {
				updateProgressHeight()
			})
		})
	}
}

extension LegDetailsView {
	var options : some View {
		Group {
			if !leg.options.isEmpty {
				if leg.options.count == 1, let option = leg.options.first {
					Button(action: {
						option.action(leg)
					}, label: {
						Label(title: {
						}, icon: {
							Image(systemName: option.icon)
								.chewTextSize(.huge)
								.frame(minWidth: 43,minHeight: 43)
								.tint(Color.gray)
						})
					})
				} else {
					Menu(content: {
						ForEach(leg.options, id:\.text) { option in
							Button(action: {
								option.action(leg)
							}, label: {
								Label(title: {
									Text(verbatim: option.text)
								}, icon: {
									Image(systemName: option.icon)
								})
							})
						}
					}, label: {
						Image(systemName: "ellipsis")
							.chewTextSize(.big)
							.frame(minWidth: 43,minHeight: 43)
							.tint(Color.gray)
					})
				}
			}
		}
	}
}

extension LegDetailsView {
	func updateProgressHeight(){
		self.currentProgressHeight = leg.progressSegments.evaluate(
			time: chewVM.referenceDate.ts ,
			type: isExpandedState
		)
		self.totalProgressHeight = leg.progressSegments.heightTotal(isExpandedState)
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
						if let viewData = leg.legViewData(
							firstTS: .now,
							lastTS: .now,
							legs: mock.legs
						) {
							LegDetailsView(
								send: {_ in },
								referenceDate: .specificDate((viewData.time.timestamp.departure.planned ?? 0) + 900),
								isExpanded: .collapsed,
								leg: viewData
							)
							.environmentObject(ChewViewModel(referenceDate: .specificDate((viewData.time.timestamp.departure.planned ?? 0) + 900)))
							.frame(minWidth: 350)
						}
					})
					ForEach(mocks,id: \.?.id) { mock in
						if let viewData = mock!.legViewData(
							firstTS: .now,
							lastTS: .now,
							legs: [mock!]
						) {
							LegDetailsView(
								send: {_ in },
								referenceDate: .specificDate((viewData.time.timestamp.departure.planned ?? 0) + 900),
								isExpanded: .collapsed,
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
			Text(verbatim: "error")
		}
	}
}
