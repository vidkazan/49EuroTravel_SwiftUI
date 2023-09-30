//
//  LegDetailsView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 18.09.23.
//

import Foundation
import SwiftUI

struct LegDetailsView: View {
	@ObservedObject var viewModel : LegDetailsViewModel
	let journeyDetailsViewModel : JourneyDetailsViewModel
	var body : some View {
		VStack {
			VStack(spacing: 0) {
				switch viewModel.state.leg.legType {
				case .transfer:
					if let stop = viewModel.state.leg.legStopsViewData.first {
						LegStopView(
							type: .transfer,
							vm: viewModel,
							stopOver: stop,
							leg: viewModel.state.leg
						)
					}
				case .line:
					if viewModel.state.leg.legStopsViewData.count > 1 {
						if let stop = viewModel.state.leg.legStopsViewData.first {
							LegStopView(
								type: .origin,
								vm: viewModel,
								stopOver: stop,
								leg: viewModel.state.leg
							)
						}
						if case .stopovers = viewModel.state.status {
							ForEach(viewModel.state.leg.legStopsViewData) { stopover in
								if stopover != viewModel.state.leg.legStopsViewData.first,stopover != viewModel.state.leg.legStopsViewData.last {
									LegStopView(
										type: .stopover,
										vm: viewModel,
										stopOver: stopover,
										leg: viewModel.state.leg
									)
								}
							}
						}
						if let stop = viewModel.state.leg.legStopsViewData.last {
							LegStopView(
								type: .destination,
								vm: viewModel,
								stopOver: stop,
								leg: viewModel.state.leg
							)
						}
					}
				case .footStart:
					if viewModel.state.leg.legStopsViewData.count > 1 {
						if let stop = viewModel.state.leg.legStopsViewData.first {
							LegStopView(
								type: .footTop,
								vm: viewModel,
								stopOver: stop,
								leg: viewModel.state.leg
							)
						}
					}
				case .footMiddle:
					if viewModel.state.leg.legStopsViewData.count > 1 {
						if let stop = viewModel.state.leg.legStopsViewData.first {
								LegStopView(
									type: .footMiddle,
									vm: viewModel,
									stopOver: stop,
									leg: viewModel.state.leg
								)
						}
					}
				case .footEnd:
					if viewModel.state.leg.legStopsViewData.count > 1 {
						if let stop = viewModel.state.leg.legStopsViewData.first {
							LegStopView(
								type: .footBottom,
								vm: viewModel,
								stopOver: stop,
								leg: viewModel.state.leg
							)
						}
					}
				}
				
			}
			.background {
				ZStack{
					switch viewModel.state.leg.legType {
					case .footEnd,.footMiddle,.footStart,.transfer:
						EmptyView()
					case .line:
						VStack{
							HStack(alignment: .top){
								Rectangle()
									.fill(Color.chewGrayScale07)
									.cornerRadius(6)
									.frame(width: 20,height: 50)
									.padding(.leading,20)
								Spacer()
							}
							Spacer()
						}
						VStack{
							HStack(alignment: .top){
								Rectangle()
									.fill(Color.chewGrayScale15)
									.cornerRadius(6)
									.frame(width: 20,height: 50)
									.padding(.leading,20)
								Spacer()
							}
							Spacer()
						}
					}
				}
			}
		}
		.padding(5)
		.onTapGesture {
			viewModel.send(event: .didtapExpandButton)
		}
		.padding(
			viewModel.state.leg.legType.description == "line" ? EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5) : EdgeInsets(top: 20, leading: 5, bottom: 20, trailing: 5)
		)
		.background{
			viewModel.state.leg.legType.description == "line" ? Color.chewGray10 : Color.clear
		}
		.cornerRadius(10)
	}
}
