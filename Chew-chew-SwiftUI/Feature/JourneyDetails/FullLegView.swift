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
				// MARK: FullLegView call
				switch viewModel.state.status {
				case .loadingFullLeg:
					Spacer()
					ProgressView()
					Spacer()
				case .fullLeg(leg: let leg):
					FullLegView(leg: leg, journeyDetailsViewModel: viewModel)
				default:
					EmptyView()
				}
				Spacer()
			}
			.chewTextSize(.big)
			.frame(maxWidth: .infinity)
			.background(Color.chewFillAccent)
			.navigationTitle("Full leg")
			.navigationBarTitleDisplayMode(.inline)
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
			VStack(alignment: .center) {
			//			 MARK: Header cell
			VStack {
				HStack(alignment: .bottom){
					BadgeView(
						.lineNumber(
							lineType:vm.state.leg.lineViewData.type ,
							num: vm.state.leg.lineViewData.name),
						.big
					)
					Spacer()
				}
				HStack(alignment: .bottom){
					BadgeView(.departureArrivalStops(
						departure: vm.state.leg.legStopsViewData.first?.name ?? "",
						arrival: vm.state.leg.legStopsViewData.last?.name ?? ""
					),.big)
					.badgeBackgroundStyle(.primary)
					Spacer()
				}
				HStack {
					BadgeView(.date(dateString: vm.state.leg.timeContainer.stringDateValue.departure.actual ?? ""))
						.badgeBackgroundStyle(.secondary)
					BadgeView(
						.timeDepartureTimeArrival(
							timeDeparture: vm.state.leg.timeContainer.stringTimeValue.departure.actual ?? "",
							timeArrival: vm.state.leg.timeContainer.stringTimeValue.arrival.actual ?? ""
						)
					)
					.badgeBackgroundStyle(.secondary)
					BadgeView(.legDuration(dur: vm.state.leg.duration))
						.badgeBackgroundStyle(.secondary)
					BadgeView(.stopsCount(vm.state.leg.legStopsViewData.count - 1,.hideShevron))
						.badgeBackgroundStyle(.secondary)
					Spacer()
				}
			}
			.padding(5)
			ScrollView {
				LazyVStack(spacing: 0) {
					switch vm.state.leg.legType {
					case .line:
						// MARK: Leg top stop
						if let stop = vm.state.leg.legStopsViewData.first {
							LegStopView(
								type: stop.stopOverType,
								vm: vm,
								stopOver: stop,
								leg: vm.state.leg,
								showBadges: false
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
										leg: vm.state.leg,
										showBadges: false
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
								leg: vm.state.leg,
								showBadges: false
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
									.fill(Color.chewFillGreenPrimary)
									.cornerRadius(vm.state.totalProgressHeight == vm.state.currentProgressHeight ? 0 : 6)
									.frame(width: 20,height: vm.state.currentProgressHeight)
									.padding(.leading,25)
								Spacer()
							}
							Spacer(minLength: 0)
						}
					}
				}
			}
		}
		.padding(5)
	}
}

struct Preview : PreviewProvider {
	static var previews: some View {
		let mock = Mock.trip.RE6NeussMinden.decodedData
		if let mock = mock?.trip,
		   let viewData = constructLegData(leg: mock, firstTS: .now, lastTS: .now, legs: [mock]) {
			FullLegView(leg: viewData, journeyDetailsViewModel: nil)
		} else {
			Text("error")
		}
	}
}
