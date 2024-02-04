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
							if let first = vm.state.data.leg.legStopsViewData.first,
							   let last = vm.state.data.leg.legStopsViewData.last {
								return [first,last]
							}
							return []
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
		.background(vm.state.data.leg.legType == LegViewData.LegType.line ? Color.chewFillAccent : .clear )
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
		let mocks = [
			Mock.trip.cancelledFirstStopRE11DussKassel.decodedData?.trip,
			Mock.trip.cancelledMiddleStopsRE6NeussMinden.decodedData?.trip,
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
								vm: LegDetailsViewModel(leg: viewData), referenceDate: .specificDate((viewData.time.timestamp.departure.planned ?? 0) + 900)
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
								vm: LegDetailsViewModel(leg: viewData), referenceDate: .specificDate((viewData.time.timestamp.departure.planned ?? 0) + 900)
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
