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
			LazyVStack {
				if let stop = viewModel.state.leg.legStopsViewData.first {
					LegStopView(
						type: .origin(viewModel.state.leg),
						vm: viewModel,
						stopOver: stop
					)
				}
				if viewModel.state.status == .stopovers {
					ForEach(viewModel.state.leg.legStopsViewData) { stopover in
						if stopover != viewModel.state.leg.legStopsViewData.first,stopover != viewModel.state.leg.legStopsViewData.last {
								LegStopView(
									type: .stopover,
									vm: viewModel,
									stopOver: stopover)
							}
						}
					}
				if let stop = viewModel.state.leg.legStopsViewData.last {
					LegStopView(
						type: .destination,
						vm: viewModel,
						stopOver: stop
					)
				}
			}
			.background {
				HStack {
					Rectangle()
//						.fill(.ultraThinMaterial.opacity(0.5))
						.fill(.gray.opacity(0.1))
						.frame(width: 20)
						.cornerRadius(8)
						.padding(5)
						.padding(.leading,15)
					Spacer()
				}
			}
		}
		.padding(5)
//		.background(.ultraThinMaterial.opacity(0.5))
		.background(.gray.opacity(0.1))
		.cornerRadius(10)
		
	}
}
