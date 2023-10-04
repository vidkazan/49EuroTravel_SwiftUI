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
					case .footEnd,.footMiddle,.footStart:
						EmptyView()
					case .line,.transfer:
						VStack{
							HStack(alignment: .top){
								Rectangle()
									.fill(Color.chewGrayScale10)
									.frame(width: 20,height:  viewModel.state.totalProgressHeight)
									.padding(.leading,25)
								Spacer()
							}
							Spacer()
						}
						VStack{
							HStack(alignment: .top){
								let _ = print(viewModel.state.totalProgressHeight,viewModel.state.currentProgressHeight,viewModel.state.leg.legType.description)
								Rectangle()
									.fill(Color.chewGreenScale20)
									.cornerRadius(viewModel.state.totalProgressHeight == viewModel.state.currentProgressHeight ? 0 : 6)
									.frame(width: 20,height: viewModel.state.currentProgressHeight)
									.padding(.leading,25)
								Spacer()
							}
							Spacer()
						}
					}
					if case .transfer=viewModel.state.leg.legType {
						Rectangle()
							.fill(Color.chewGrayScale07.opacity(0.6))
							.frame(height: StopOverType.transfer.viewHeight - 20)
							.cornerRadius(10)
					}
				}
			}
		}
		.onTapGesture {
			if case .line=viewModel.state.leg.legType {
				viewModel.send(event: .didtapExpandButton)
			}
		}
		.padding(.vertical,5)
		.background{
			switch viewModel.state.leg.legType {
			case .line:
				Color.chewGray10
			case .footStart,.footMiddle, .footEnd,.transfer:
				Color.clear
			}
		}
		.cornerRadius(10)
	}
}
