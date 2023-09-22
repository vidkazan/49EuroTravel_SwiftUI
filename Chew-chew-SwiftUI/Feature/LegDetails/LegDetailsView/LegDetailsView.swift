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
	var body : some View {
		VStack {
			VStack {
				switch viewModel.state.leg.legType {
				case .foot(place: let place):
					if viewModel.state.leg.legStopsViewData.count > 1 {
						if let stop = viewModel.state.leg.legStopsViewData.first {
							LegStopView(
								type: .foot(place),
								vm: viewModel,
								stopOver: stop,
								leg: viewModel.state.leg
							)
						}
					}
				case .transfer:
					HStack(spacing: 3) {
						BadgeView(badge: .legDuration(dur: viewModel.state.leg.duration))
						Spacer()
					}
					.frame(height: 30)
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
						if viewModel.state.status == .stopovers {
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
				}
				
			}
			.background {
				HStack {
					if case .foot=viewModel.state.leg.legType {
						EmptyView()
					} else if case.transfer=viewModel.state.leg.legType  {
						EmptyView()
					} else {
						Rectangle()
							.fill(.gray.opacity(0.1))
							.frame(width: 20)
							.cornerRadius(8)
							.padding(5)
							.padding(.leading,15)
						Spacer()
					}
				}
			}
		}
		.onTapGesture {
			viewModel.send(event: .didtapExpandButton)
		}
		.padding(
			viewModel.state.leg.legType.description == "line" ? EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5) : EdgeInsets(top: 20, leading: 5, bottom: 20, trailing: 5)
		)
		.background{
			viewModel.state.leg.legType.description == "line" ? Color.gray.opacity(0.1) : Color.clear
		}
		.cornerRadius(10)
	}
}
