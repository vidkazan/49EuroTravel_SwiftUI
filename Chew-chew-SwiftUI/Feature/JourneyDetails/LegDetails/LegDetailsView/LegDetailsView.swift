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
	@State var currentProgressHeight : Double = 0
	let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
	let followedJourney : Bool
	@ObservedObject var vm : LegDetailsViewModel
	let sendToJourneyVM : ((JourneyDetailsViewModel.Event)->Void)?
		
	init(
		followedJourney: Bool = false,
		send : @escaping (JourneyDetailsViewModel.Event) -> Void,
		vm : LegDetailsViewModel
	) {
		self.vm = vm
		self.followedJourney = followedJourney
		self.sendToJourneyVM = send
		self.currentProgressHeight = currentProgressHeight
	}
	var body : some View {
		VStack {
			VStack(spacing: 0) {
				// MARK: Stop foot + transfer
				switch vm.state.data.leg.legType {
				case .transfer,.footMiddle:
					if let stop = vm.state.data.leg.legStopsViewData.first {
						LegStopView(
							type: stop.stopOverType,
							vm: vm,
							stopOver: stop,
							leg: vm.state.data.leg,
							showBadges : !followedJourney
						)
					}
				case .footStart:
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
							type: stop.stopOverType,
							vm: vm,
							stopOver: stop,
							leg: vm.state.data.leg,
							showBadges : !followedJourney
						)
						.padding(.bottom,10)
					}
				// MARK: Stop line
				case .line:
					if let stop = vm.state.data.leg.legStopsViewData.first {
						LegStopView(
							type: stop.stopOverType,
							vm: vm,
							stopOver: stop,
							leg: vm.state.data.leg,
							showBadges : !followedJourney
						)
					}
					if case .stopovers = vm.state.status {
						ForEach(vm.state.data.leg.legStopsViewData) { stop in
							if stop != vm.state.data.leg.legStopsViewData.first,stop != vm.state.data.leg.legStopsViewData.last {
								LegStopView(
									type: stop.stopOverType,
									vm: vm,
									stopOver: stop,
									leg: vm.state.data.leg,
									showBadges : !followedJourney
								)
							}
						}
					}
					if let stop = vm.state.data.leg.legStopsViewData.last {
						LegStopView(
							type: stop.stopOverType,
							vm: vm,
							stopOver: stop,
							leg: vm.state.data.leg,
							showBadges : !followedJourney
						)
					}
				}
			}
			.background {
				ZStack(alignment: .top) {
					// MARK: BG - progress line
					VStack{
						HStack(alignment: .top) {
							Rectangle()
								.fill(Color.chewProgressLineGray)
								.frame(width: 20,height:  vm.state.data.totalProgressHeight)
								.padding(.leading,24)
							Spacer()
						}
						Spacer(minLength: 0)
					}
					VStack {
						HStack(alignment: .top) {
							RoundedRectangle(
								cornerRadius : vm.state.data.totalProgressHeight == currentProgressHeight ? 0 : 6
							)
							.fill(Color.chewFillGreenPrimary)
								.frame(width: 22,height: currentProgressHeight)
								.padding(.leading,24)
							Spacer()
						}
						Spacer(minLength: 0)
					}
					.shadow(radius: 2)
					// MARK: BG - colors
					switch vm.state.data.leg.legType {
					case .transfer,.footMiddle:
						VStack {
							Spacer()
							Color.chewFillAccent.opacity(0.6)
								.frame(height: vm.state.data.totalProgressHeight - 20)
								.cornerRadius(10)
							Spacer()
						}
					case .footStart:
						Color.chewFillAccent.opacity(0.6)
							.frame(height: vm.state.data.totalProgressHeight)
							.cornerRadius(10)
							.offset(y: -10)
					case .footEnd:
						Color.chewFillAccent.opacity(0.6)
							.frame(height: vm.state.data.totalProgressHeight)
							.cornerRadius(10)
							.offset(y: 10)
					case .line:
						EmptyView()
					}
				}
				.frame(maxHeight: .infinity)
			}
		}
		.onAppear {
			self.currentProgressHeight = vm.state.data.leg.progressSegments.evaluate(time: Date.now.timeIntervalSince1970 , type: vm.state.status == .stopovers ? .expanded : .collapsed)
		}
		.onReceive(timer, perform: { timer in
			currentProgressHeight = vm.state.data.leg.progressSegments.evaluate(
				time: Date.now.timeIntervalSince1970,
				type: vm.state.status == .stopovers ? .expanded : .collapsed
			)
		})
		.onChange(of: vm.state.status, perform: { _ in
			currentProgressHeight = vm.state.data.currentProgressHeight
		})
		// MARK: 🤢
		.padding(.top,vm.state.data.leg.legType == LegViewData.LegType.line || vm.state.data.leg.legType.caseDescription == "footStart" ?  10 : 0)
		.background(vm.state.data.leg.legType == LegViewData.LegType.line ? Color.chewFillSecondary : .clear )
		.cornerRadius(10)
		.onTapGesture {
			vm.send(event: .didTapExpandButton)
		}
		// MARK: longGesture
		.onLongPressGesture(minimumDuration: 0.3,maximumDistance: 10, perform: {
			sendToJourneyVM?(.didLongTapOnLeg(leg: vm.state.data.leg))
		})
	}
}



struct LegDetailsPreview : PreviewProvider {
	static var previews : some View {
		let mock = Mock.journeys.journeyNeussWolfsburg.decodedData
		if let mock = mock?.journey {
			ScrollView {
				ForEach(mock.legs, content: { leg in
					if let viewData = constructLegData(
						leg: leg,
						firstTS: .now,
						lastTS: .now,
						legs: mock.legs
					) {
						LegDetailsView(
							send: {_ in },
							vm: LegDetailsViewModel(leg: viewData)
						)
						.padding(.horizontal,10)
					}
				})
			}
			.previewDevice(PreviewDevice(stringLiteral: "iPhone SE (3rd generation)"))
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
