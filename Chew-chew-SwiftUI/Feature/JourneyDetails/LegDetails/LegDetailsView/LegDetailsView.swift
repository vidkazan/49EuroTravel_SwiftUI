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
				case .transfer,.footMiddle,.footEnd,.footStart:
					if let stop = viewModel.state.leg.legStopsViewData.first {
						LegStopView(
							type: stop.type,
							vm: viewModel,
							stopOver: stop,
							leg: viewModel.state.leg
						)
					}
				case .line:
					if let stop = viewModel.state.leg.legStopsViewData.first {
						LegStopView(
							type: stop.type,
							vm: viewModel,
							stopOver: stop,
							leg: viewModel.state.leg
						)
					}
					if case .stopovers = viewModel.state.status {
						ForEach(viewModel.state.leg.legStopsViewData) { stop in
							if stop != viewModel.state.leg.legStopsViewData.first,stop != viewModel.state.leg.legStopsViewData.last {
								LegStopView(
									type: stop.type,
									vm: viewModel,
									stopOver: stop,
									leg: viewModel.state.leg
								)
							}
						}
					}
					if let stop = viewModel.state.leg.legStopsViewData.last {
						LegStopView(
							type: stop.type,
							vm: viewModel,
							stopOver: stop,
							leg: viewModel.state.leg
						)
					}
				}
			}
			.background {
				ZStack {
					switch viewModel.state.leg.legType {
					case .footEnd,.footMiddle,.footStart,.transfer:
						EmptyView()
					case .line:
						VStack{
							HStack(alignment: .top){
								Rectangle()
									.fill(Color.chewGrayScale07)
									.frame(width: 20,height:  viewModel.state.totalProgressHeight)
									.padding(.leading,20)
								Spacer()
							}
							Spacer()
						}
						VStack{
							HStack(alignment: .top){
								Rectangle()
									.fill(Color.chewRedScale20)
									.cornerRadius(viewModel.state.totalProgressHeight == viewModel.state.currentProgressHeight ? 0 : 6)
									.frame(width: 20,height: viewModel.state.currentProgressHeight)
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
