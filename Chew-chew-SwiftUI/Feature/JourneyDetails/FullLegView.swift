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
		VStack(alignment: .center,spacing: 0) {
			// MARK: Header label
			Label("Full leg", systemImage: "arrow.up.left.and.arrow.down.right.circle")
				.chewTextSize(.big)
				.padding(10)
			// MARK: FullLegView
			switch viewModel.state.status {
			case .loadingFullLeg:
				Spacer()
				ProgressView()
				Spacer()
			case .fullLeg(leg: let leg):
				FullLegView(leg: leg, journeyDetailsViewModel: viewModel)
			case .error,.loadedJourneyData,.loading,.actionSheet,.loadingLocationDetails,.locationDetails:
				Spacer()
				Text("Error")
				Spacer()
			}
			Spacer()
			// MARK: Close button
			Button("Close") {
				viewModel.send(event: .didCloseBottomSheet)
			}
			.frame(maxWidth: .infinity,minHeight: 43)
			.background(Color.chewGray15)
			.foregroundColor(.primary)
			.cornerRadius(10)
			.padding(5)
		}
		.chewTextSize(.big)
		.background(Color.chewGrayScale07)
	}
}


// MARK: FullLegView
struct FullLegView: View {
	@ObservedObject var vm : LegDetailsViewModel
	let journeyVM : JourneyDetailsViewModel
	init(leg : LegViewData,journeyDetailsViewModel: JourneyDetailsViewModel) {
		self.vm = LegDetailsViewModel(leg: leg,isExpanded: true)
		self.journeyVM = journeyDetailsViewModel
	}
	var body : some View {
		VStack(alignment: .center) {
			// MARK: Header
			fullLegHeader()
				.animation(nil, value: journeyVM.state)
				VStack {
					ScrollView {
						LazyVStack {
							VStack(spacing: 0) {
								switch vm.state.leg.legType {
								case .line:
									// MARK: Leg top stop
									if let stop = vm.state.leg.legStopsViewData.first {
										LegStopView(
											type: stop.type,
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
													type: stop.type,
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
											type: stop.type,
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
											Rectangle()
												.fill(Color.chewGreenScale20)
												.cornerRadius(vm.state.totalProgressHeight == vm.state.currentProgressHeight ? 0 : 6)
												.frame(width: 20,height: vm.state.currentProgressHeight)
												.padding(.leading,25)
											Spacer()
										}
										Spacer(minLength: 0)
									}
								}
								.frame(maxHeight: .infinity)
							}
						}
					}
					.padding(.top,10)
					.background(Color.chewGrayScale07)
					.cornerRadius(10)
					.padding(5)
					Spacer()
				}
		}
		.frame(maxWidth: .infinity)
		.background(Color.chewGrayScale05)
	}
}


// MARK: FullLegView - Header
extension FullLegView {

	func fullLegHeader() -> some View {
		VStack(alignment: .leading) {
			VStack {
				// MARK: From-To
				HStack {
					HStack {
						Text(vm.state.leg.legStopsViewData.first?.name ?? "first")
							.chewTextSize(.big)
							.foregroundColor(.primary)
						Image(systemName: "arrow.right")
						Text(vm.state.leg.legStopsViewData.last?.name ?? "last")
							.chewTextSize(.big)
							.foregroundColor(.primary)
					}
					.padding(7)
					.background(Color.chewGray10)
					.cornerRadius(10)
					Spacer()
				}
				HStack {
					// MARK: Date
					HStack {
						Text(DateParcer.getDateOnlyStringFromDate(date: vm.state.leg.timeContainer.date.departure.actual ?? .now))
					}
					.padding(5)
					.chewTextSize(.medium)
					.background(Color.chewGray10)
					.foregroundColor(.primary.opacity(0.6))
					.cornerRadius(8)
					// MARK: Time
					HStack {
						Text(vm.state.leg.timeContainer.stringValue.departure.actual ?? "time")
						Text("-")
						Text(vm.state.leg.timeContainer.stringValue.arrival.actual ?? "time")
					}
					.padding(5)
					.chewTextSize(.medium)
					.background(Color.chewGray10)
					.foregroundColor(.primary.opacity(0.6))
					.cornerRadius(8)
					// MARK: Duration
					Text(vm.state.leg.duration)
						.padding(5)
						.chewTextSize(.medium)
						.background(Color.chewGray10)
						.foregroundColor(.primary.opacity(0.6))
						.cornerRadius(8)
					Spacer()
				}
			}
			
		}
	}
}
