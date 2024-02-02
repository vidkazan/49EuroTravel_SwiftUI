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
	@ObservedObject var vm : LegDetailsViewModel
	@State var currentProgressHeight : Double = 0
	
	let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
	let followedJourney : Bool
	let sendToJourneyVM : ((JourneyDetailsViewModel.Event)->Void)?
		
	init(
		followedJourney: Bool = false,
		send : @escaping (JourneyDetailsViewModel.Event) -> Void,
		vm : LegDetailsViewModel,
		referenceDate : ChewDate
	) {
		self.vm = vm
		self.followedJourney = followedJourney
		self.sendToJourneyVM = send
		self.currentProgressHeight = vm.state.data.leg.progressSegments.evaluate(
			time: referenceDate.ts,
			type: vm.state.status.evalType
		)
	}
	
	var body : some View {
		VStack {
			VStack(spacing: 0) {
				// MARK: Stop foot + transfer
				switch vm.state.data.leg.legType {
				case .transfer,.footMiddle,.footStart:
					if let stop = vm.state.data.leg.legStopsViewData.first {
						LegStopView(
							type: stop.stopOverType,
							vm: vm,
							stopOver: stop,
							leg: vm.state.data.leg,
							showBadges : !followedJourney
						)
					}
				case .footEnd:
					if let stop = vm.state.data.leg.legStopsViewData.last {
						LegStopView(
							vm: vm,
							stopOver: stop,
							leg: vm.state.data.leg,
							showBadges : !followedJourney
						)
						.padding(.bottom,10)
					}
				// MARK: Stop line
				case .line:
					let stops : [StopViewData] = {
						switch vm.state.status {
						case .stopovers:
							return vm.state.data.leg.legStopsViewData
						default:
							return [
								vm.state.data.leg.legStopsViewData.first!,
								vm.state.data.leg.legStopsViewData.last!
							]
						}
					}()
					ForEach(stops) { stop in
						LegStopView(
							vm: vm,
							stopOver: stop,
							leg: vm.state.data.leg,
							showBadges : !followedJourney
						)
					}
				}
			}
			.background { background }
		}
		// MARK: 🤢
		.padding(.top,vm.state.data.leg.legType == LegViewData.LegType.line || vm.state.data.leg.legType.caseDescription == "footStart" ?  10 : 0)
		.background(vm.state.data.leg.legType == LegViewData.LegType.line ? Color.chewFillSecondary : .clear )
		.cornerRadius(10)
		.onAppear {
			self.currentProgressHeight = vm.state.data.leg.progressSegments.evaluate(time: chewVM.referenceDate.ts , type: vm.state.status.evalType)
		}
		.onReceive(timer, perform: { timer in
			currentProgressHeight = vm.state.data.leg.progressSegments.evaluate(
				time: chewVM.referenceDate.ts,
				type: vm.state.status.evalType
			)
		})
		.onReceive(vm.$state, perform: { state in
			currentProgressHeight = state.data.currentProgressHeight
		})
		.onTapGesture {
			if vm.state.data.leg.legType == .line {
				vm.send(event: .didTapExpandButton(refTimeTS: chewVM.referenceDate.ts))
			}
		}
		.onLongPressGesture(minimumDuration: 0.3,maximumDistance: 10, perform: {
			sendToJourneyVM?(.didLongTapOnLeg(leg: vm.state.data.leg))
		})
	}
}



@available(iOS 16.0, *)
struct LegDetailsPreview : PreviewProvider {
	static var previews : some View {
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
								vm: LegDetailsViewModel(leg: viewData), referenceDate: .specificDate((viewData.timeContainer.timestamp.departure.planned ?? 0) + 1000)
							)
							.environmentObject(ChewViewModel(referenceDate: .specificDate((viewData.timeContainer.timestamp.departure.planned ?? 0) + 1000)))
							.frame(minWidth: 350)
							.padding(.horizontal,10)
						}
					})
					let mock = Mock.trip.cancelledFirstStopRE11DussKassel.decodedData?.trip
					if let viewData = constructLegData(
						leg: mock!,
						firstTS: .now,
						lastTS: .now,
						legs: [mock!]
					) {
						LegDetailsView(
							send: {_ in },
							vm: LegDetailsViewModel(leg: viewData), referenceDate: .specificDate((viewData.timeContainer.timestamp.departure.planned ?? 0) + 20000)
						)
						.environmentObject(ChewViewModel(referenceDate: .specificDate((viewData.timeContainer.timestamp.departure.planned ?? 0) + 20000)))
						.frame(minWidth: 350)
						.padding(.horizontal,10)
					}
					let mock2 = Mock.trip.cancelledMiddleStopsRE6NeussMinden.decodedData?.trip
					if let viewData = constructLegData(
						leg: mock2!,
						firstTS: .now,
						lastTS: .now,
						legs: [mock2!]
					) {
						LegDetailsView(
							send: {_ in },
							vm: LegDetailsViewModel(leg: viewData),
							referenceDate: .specificDate((viewData.timeContainer.timestamp.departure.planned ?? 0) + 20000)
						)
						.environmentObject(ChewViewModel(referenceDate: .specificDate((viewData.timeContainer.timestamp.departure.planned ?? 0) + 20000)))
						.frame(minWidth: 350)
						.padding(.horizontal,10)
					}
//					let mock3 = Mock.trip.cancelledLastStopRE11DussKassel.decodedData?.trip
//					if let viewData = constructLegData(
//						leg: mock3!,
//						firstTS: .now,
//						lastTS: .now,
//						legs: [mock3!]
//					) {
//						LegDetailsView(
//							send: {_ in },
//							vm: LegDetailsViewModel(leg: viewData)
//						)
//						.frame(minWidth: 350)
//						.padding(.horizontal,10)
//					}
				}
			}
			.previewDevice(PreviewDevice(.iPadMini6gen))
			.previewInterfaceOrientation(.landscapeLeft)
		} else {
			Text("error")
		}
	}
}

//struct LegDetailsStopPreview : PreviewProvider {
//	static var previews : some View {
//		let mock = Mock.trip.RE6NeussMinden.decodedData
//		if let mock = mock?.trip,
//		   let viewData = constructLegData(leg: mock, firstTS: .now, lastTS: .now, legs: [mock]) {
//			ScrollView(.horizontal) {
//				HStack {
//					VStack {
//						ForEach(StopOverType.allCases, id: \.rawValue, content: {type in
//							LegStopView(
//								type: type,
//								vm: .init(leg: viewData),
//								stopOver: viewData.legStopsViewData[1],
//								leg: viewData,
//								showBadges: false
//							)
//						})
//					}
//					.padding(5)
//					.border(.gray)
//					VStack {
//						ForEach(StopOverType.allCases, id: \.rawValue, content: {type in
//							LegStopView(
//								type: type,
//								vm: .init(leg: viewData),
//								stopOver: viewData.legStopsViewData[6],
//								leg: viewData,
//								showBadges: false
//							)
//						})
//					}
//					.padding(5)
//					.border(.gray)
//				}
//			}
//			.previewDevice(PreviewDevice(stringLiteral: "iPad mini (6th generation)"))
//		} else {
//			Text("error")
//		}
//	}
//}
