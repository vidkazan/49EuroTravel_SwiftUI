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
	init(leg : LegViewData, journeyDetailsViewModel: JourneyDetailsViewModel) {
		self.viewModel = LegDetailsViewModel(leg: leg)
		self.journeyDetailsViewModel = journeyDetailsViewModel
	}
	
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
						.padding(.top,10)
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
				ZStack(alignment: .top) {
						HStack {
							Rectangle()
								.fill(Color.chewGrayScale10)
								.frame(width: 18,height:  viewModel.state.totalProgressHeight)
								.padding(.leading,26)
							Spacer()
						}
						HStack {
							Rectangle()
								.fill(Color.chewGreenScale20)
								.cornerRadius(viewModel.state.totalProgressHeight == viewModel.state.currentProgressHeight ? 0 : 6)
								.frame(width: 20,height: viewModel.state.currentProgressHeight)
								.padding(.leading,25)
							Spacer()
						}
					switch viewModel.state.leg.legType {
					case .transfer,.footMiddle:
						VStack{
							Spacer()
							Rectangle()
								.fill(Color.chewGrayScale07.opacity(0.6))
								.frame(height: viewModel.state.totalProgressHeight - 20)
								.cornerRadius(10)
							Spacer()
						}
					case .line,.footStart,.footEnd:
						EmptyView()
					}
				}
				.frame(height: viewModel.state.totalProgressHeight)
			}
		}
		.onTapGesture {
			if case .line=viewModel.state.leg.legType {
				viewModel.send(event: .didtapExpandButton)
			}
		}
		.background{
			switch viewModel.state.leg.legType {
			case .line,.footStart,.footEnd:
				Color.chewGray10
			case .footMiddle,.transfer:
				Color.clear
			}
		}
		.cornerRadius(10)
	}
}
