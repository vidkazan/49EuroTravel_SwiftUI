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
			// MARK: Close button
			Button("Close") {
				viewModel.send(event: .didCloseBottomSheet)
			}
			
			.frame(maxWidth: .infinity,minHeight: 40)
			.background(Color.chewGray15)
			.foregroundColor(.primary)
			.cornerRadius(10)
			.padding(5)
		}
		.chewTextSize(.big)
		.frame(maxWidth: .infinity)
		.background(Color.chewGrayScale05)
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
			// MARK: Header call
			fullLegHeader()
				.padding(.horizontal,10)
			VStack {
				ScrollView {
					LazyVStack {
						VStack(spacing: 0) {
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
	}
}


// MARK: Header
extension FullLegView {
	func fullLegHeader() -> some View {
		VStack(alignment: .leading) {
			VStack {
				// MARK: Train Number +  From-To
				HStack {
					Spacer()
				}
				HStack {
					BadgeView(
						badge: .lineNumber(
							lineType:vm.state.leg.lineViewData.type,
							num: vm.state.leg.lineViewData.name
						),
						isBig: true
					)
					BadgeView(
						badge: .legDirection(
							dir: vm.state.leg.direction
						),
						isBig: true
					)
					Spacer()
				}
				HStack {
					// MARK: Date
					HStack {
						Text(vm.state.leg.timeContainer.stringDateValue.departure.actual ??
							 vm.state.leg.timeContainer.stringDateValue.departure.planned ??
							 "date"
						)
					}
					.padding(5)
					.chewTextSize(.medium)
					.background(Color.chewGray10)
					.foregroundColor(.primary.opacity(0.6))
					.cornerRadius(8)
					// MARK: Time
					HStack {
						Text(vm.state.leg.timeContainer.stringTimeValue.departure.actual ??
							 vm.state.leg.timeContainer.stringTimeValue.departure.planned ??
							 "time")
						Text("-")
						Text(vm.state.leg.timeContainer.stringTimeValue.arrival.actual ??
							 vm.state.leg.timeContainer.stringTimeValue.arrival.planned ??
							 "time")
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
