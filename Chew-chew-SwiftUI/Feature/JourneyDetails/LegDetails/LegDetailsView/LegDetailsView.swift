//
//  LegDetailsView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 18.09.23.
//

import Foundation
import SwiftUI

struct LegDetailsView: View {
	@ObservedObject var vm : LegDetailsViewModel
	init(leg : LegViewData, journeyDetailsViewModel: JourneyDetailsViewModel) {
		self.vm = LegDetailsViewModel(leg: leg)
	}
	
	var body : some View {
		VStack {
			VStack(spacing: 0) {
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
					if let stop = vm.state.leg.legStopsViewData.first {
						LegStopView(
							type: stop.type,
							vm: vm,
							stopOver: stop,
							leg: vm.state.leg
						)
					}
				case .line:
					if let stop = vm.state.leg.legStopsViewData.first {
						LegStopView(
							type: stop.type,
							vm: vm,
							stopOver: stop,
							leg: vm.state.leg
						)
//						.padding(.top,10)
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
					// MARK: Background for but Line
					switch vm.state.leg.legType {
					case .transfer,.footMiddle:
						VStack{
							Spacer()
							Rectangle()
								.fill(Color.chewGrayScale07.opacity(0.6))
								.frame(height: vm.state.totalProgressHeight - 20)
								.cornerRadius(10)
							Spacer()
						}
					case .footStart:
						Rectangle()
							.fill(Color.chewGrayScale07.opacity(0.6))
							.frame(height: vm.state.totalProgressHeight)
							.cornerRadius(10)
							.offset(y: -10)
					case .footEnd:
						Rectangle()
							.fill(Color.chewGrayScale07.opacity(0.6))
							.frame(height: vm.state.totalProgressHeight)
							.cornerRadius(10)
							.offset(y: 10)
					case .line:
						EmptyView()
					}
				}
//				.frame(height: vm.state.totalProgressHeight)
				.frame(maxHeight: .infinity)
			}
		}
		.onTapGesture {
			if case .line=vm.state.leg.legType {
				vm.send(event: .didtapExpandButton)
			}
		}
		// MARK: Background for Line
		.background{
			switch vm.state.leg.legType {
			case .line:
				Color.chewGray11
			case .footMiddle,.transfer,.footStart,.footEnd:
				Color.clear
			}
		}
		.cornerRadius(10)
	}
}
