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
	@ObservedObject var vm : LegDetailsViewModel
	let journeyVM : JourneyDetailsViewModel
	init(leg : LegViewData, journeyDetailsViewModel: JourneyDetailsViewModel) {
		self.vm = LegDetailsViewModel(leg: leg)
		self.journeyVM = journeyDetailsViewModel
	}
	var body : some View {
		VStack {
			VStack(spacing: 0) {
				// MARK: Stop foot + transfer
				switch vm.state.leg.legType {
				case .transfer,.footMiddle:
					if let stop = vm.state.leg.legStopsViewData.first {
						LegStopView(
							type: stop.type,
							vm: vm,
							stopOver: stop,
							leg: vm.state.leg
						)
					}
				case .footStart:
					if let stop = vm.state.leg.legStopsViewData.first {
						LegStopView(
							type: stop.type,
							vm: vm,
							stopOver: stop,
							leg: vm.state.leg
						)
					}
				case .footEnd:
					if let stop = vm.state.leg.legStopsViewData.last {
						LegStopView(
							type: stop.type,
							vm: vm,
							stopOver: stop,
							leg: vm.state.leg
						)
						.padding(.bottom,10)
					}
				// MARK: Stop line
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
				}
			}
			.background {
				ZStack(alignment: .top) {
					// MARK: BG - progress line
					VStack{
						HStack(alignment: .top) {
							Rectangle()
								.fill(Color.chewGrayScale10)
								.frame(width: 20,height:  vm.state.totalProgressHeight)
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
								.frame(width: 22,height: vm.state.currentProgressHeight)
								.padding(.leading,25)
							Spacer()
						}
						Spacer(minLength: 0)
					}
					// MARK: BG - colors
					switch vm.state.leg.legType {
					case .transfer,.footMiddle:
						VStack {
							Spacer()
							Color.chewGrayScale07.opacity(0.6)
								.frame(height: vm.state.totalProgressHeight - 20)
								.cornerRadius(10)
							Spacer()
						}
					case .footStart:
						Color.chewGrayScale07.opacity(0.6)
							.frame(height: vm.state.totalProgressHeight)
							.cornerRadius(10)
							.offset(y: -10)
					case .footEnd:
						Color.chewGrayScale07.opacity(0.6)
							.frame(height: vm.state.totalProgressHeight)
							.cornerRadius(10)
							.offset(y: 10)
					case .line:
						EmptyView()
					}
				}
				.frame(maxHeight: .infinity)
			}
		}
		// MARK: 🤢
		.padding(.top,vm.state.leg.legType == LegViewData.LegType.line || vm.state.leg.legType.caseDescription == "footStart" ?  10 : 0)
		.background(vm.state.leg.legType == LegViewData.LegType.line ? Color.chewGray11 : .clear )
		.cornerRadius(10)
		.onTapGesture {
			if case .line=vm.state.leg.legType {
				vm.send(event: .didtapExpandButton)
			}
		}
		// MARK: longGesture
		.onLongPressGesture(minimumDuration: 0.3,maximumDistance: 10, perform: {
			journeyVM.send(event: .didLongTapOnLeg(leg: vm.state.leg))
		})
	}
}
