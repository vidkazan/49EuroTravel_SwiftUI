//
//  FullLegView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 19.10.23.
//

import Foundation
import SwiftUI

struct FullLegView: View {
	@ObservedObject var vm : LegDetailsViewModel
	let journeyVM : JourneyDetailsViewModel
	init(leg : LegViewData, journeyDetailsViewModel: JourneyDetailsViewModel) {
		self.vm = LegDetailsViewModel(leg: leg,isExpanded: true)
		self.journeyVM = journeyDetailsViewModel
	}
	var body : some View {
		VStack {
			Label("Full leg", systemImage: "arrow.up.left.and.arrow.down.right.circle")
				.chewTextSize(.big)
				.padding(10)
			switch journeyVM.state.status {
			case .loadingFullLeg:
				Spacer()
				ProgressView()
				Spacer()
			case .fullLeg(leg: let leg):
				VStack {
					ScrollView {
						LazyVStack {
							VStack(spacing: 0) {
								switch leg.legType {
								case .line:
									if let stop = vm.state.leg.legStopsViewData.first {
										LegStopView(
											type: stop.type,
											vm: vm,
											stopOver: stop,
											leg: vm.state.leg
										)
									}
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
							.background {
								ZStack(alignment: .top) {
									// MARK: Full Line
									VStack{
										HStack(alignment: .top) {
											Rectangle()
												.fill(Color.chewGrayScale10)
												.frame(width: 18,height:  vm.state.totalProgressHeight)
												.padding(.leading,26)
											Spacer()
										}
										Spacer(minLength: 0)
										// MARK: Progress Line
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
					Button("Close") {
						journeyVM.send(event: .didCloseBottomSheet)
					}
					.frame(maxWidth: .infinity,minHeight: 43)
					.background(Color.chewGray15)
					.foregroundColor(.primary)
					.cornerRadius(10)
					.padding(5)
				}
			case .error,.loadedJourneyData,.loading,.actionSheet,.loadingLocationDetails,.locationDetails:
				Spacer()
				Text("Error")
				Spacer()
			}
		}
		.frame(maxWidth: .infinity)
		.background(Color.chewGrayScale05)
	}
}
