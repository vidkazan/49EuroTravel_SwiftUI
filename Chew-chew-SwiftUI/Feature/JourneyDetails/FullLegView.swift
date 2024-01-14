//
//  FullLegView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 19.10.23.
//

import Foundation
import SwiftUI

// MARK: FullLegSheet
struct FullLegSheet: View {
	@ObservedObject var viewModel : JourneyDetailsViewModel
	var body: some View {
		NavigationView {
			VStack(alignment: .center,spacing: 0) {
				// MARK: Header label
//				Label("Full leg", systemImage: "arrow.up.left.and.arrow.down.right.circle")
//					.chewTextSize(.big)
//					.padding(10)
				// MARK: FullLegView call
				switch viewModel.state.status {
				case .loadingFullLeg:
					Spacer()
					ProgressView()
					Spacer()
				case .fullLeg(leg: let leg):
					FullLegView(leg: leg, journeyDetailsViewModel: viewModel)
				case .error,.loadedJourneyData,.loading,.actionSheet,.loadingLocationDetails,.locationDetails,.changingSubscribingState,.loadingIfNeeded:
					Spacer()
					Text("Error")
					Spacer()
				}
				Spacer()
			}
			.chewTextSize(.big)
			.frame(maxWidth: .infinity)
//			.background(Color.chewGrayScale05)
//			.navigationBarHidden(true)
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading, content: {
					Button("Close") {
						viewModel.send(event: .didCloseBottomSheet)
					}
				})
			}
		}
	}
}


// MARK: FullLegView
struct FullLegView: View {
	@ObservedObject var vm : LegDetailsViewModel
	weak var journeyVM : JourneyDetailsViewModel?
	init(leg : LegViewData,journeyDetailsViewModel: JourneyDetailsViewModel?) {
		self.vm = LegDetailsViewModel(leg: leg,isExpanded: true)
		self.journeyVM = journeyDetailsViewModel
	}
	var body : some View {
//		VStack(alignment: .center) {
//			 MARK: Header call
				ScrollView {
					VStack(spacing: 2) {
						HStack(spacing: 2) {
							BadgeView(
								.lineNumber(
									lineType:vm.state.leg.lineViewData.type ,
									num: vm.state.leg.lineViewData.name),
								.big
							)
							BadgeView(
								.legDirection(dir: vm.state.leg.direction),
								.big
							)
							.badgeBackgroundStyle(.primary)
							Spacer()
						}
						HStack(spacing: 2) {
							BadgeView(.legDuration(dur: vm.state.leg.duration))
								.badgeBackgroundStyle(.secondary)
							BadgeView(.stopsCount(vm.state.leg.legStopsViewData.count - 1))
								.badgeBackgroundStyle(.secondary)
							Spacer()
						}
						.padding(3)
					}
					.padding(5)
					.badgeBackgroundStyle(.secondary)
					.padding(5)
					LazyVStack(spacing: 0) {
						switch vm.state.leg.legType {
						case .line:
							// MARK: Leg top stop
							if let stop = vm.state.leg.legStopsViewData.first {
								LegStopView(
									type: stop.stopOverType,
									vm: vm,
									stopOver: stop,
									leg: vm.state.leg
								)
							}
							// MARK: Leg midlle stops
							if case .stopovers = vm.state.status {
								ForEach(vm.state.leg.legStopsViewData) { stop in
									if stop != vm.state.leg.legStopsViewData.first,stop != vm.state.leg.legStopsViewData.last {
										LegStopView(
											type: stop.stopOverType,
											vm: vm,
											stopOver: stop,
											leg: vm.state.leg
										)
									}
								}
							}
							// MARK: Leg bottom stop
							if let stop = vm.state.leg.legStopsViewData.last {
								LegStopView(
									type: stop.stopOverType,
									vm: vm,
									stopOver: stop,
									leg: vm.state.leg
								)
							}
						default:
							Text("error")
						}
					}
					// MARK: Progress line
					.background {
						ZStack(alignment: .top) {
							VStack{
								HStack(alignment: .top) {
									Rectangle()
										.fill(Color.chewGrayScale10)
										.frame(width: 18,height:  vm.state.totalProgressHeight)
										.padding(.leading,26)
									Spacer()
								}
								Spacer(minLength: 0)
							}
							VStack {
								HStack(alignment: .top) {
									RoundedRectangle(cornerRadius: vm.state.totalProgressHeight == vm.state.currentProgressHeight ? 0 : 6)
										.fill(Color.chewGreenScale20)
										.cornerRadius(vm.state.totalProgressHeight == vm.state.currentProgressHeight ? 0 : 6)
										.frame(width: 20,height: vm.state.currentProgressHeight)
										.padding(.leading,25)
									Spacer()
								}
								Spacer(minLength: 0)
							}
						}
//						.frame(maxHeight: .infinity)
//						.background(Color.chewGrayScale07)
					}
				}
				.cornerRadius(10)
				.padding(5)
				Spacer()
	}
}

struct Preview : PreviewProvider {
	static var previews: some View {
		let mock = Mock.trip.RE6NeussMinden.decodedData
		if let mock = mock?.trip {
			let viewData = constructLegData(leg: mock, firstTS: .now, lastTS: .now, legs: [mock])
			FullLegView(leg: viewData!, journeyDetailsViewModel: nil)
		} else {
			Text("error")
		}
	}
}
