//
//  JourneyDetails.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.09.23.
//

import SwiftUI
import MapKit

extension JourneyDetailsView {
	@ViewBuilder func follow() -> some View {
		Button(
			action: {
				switch viewModel.state.status {
				case .loading:
					break
				default:
					viewModel.send(event: .didTapSubscribingButton(
						id: viewModel.state.data.id,
						ref: viewModel.state.data.viewData.refreshToken,
						journeyDetailsViewModel: viewModel
					))
				}
			},
			label: {
				switch viewModel.state.status {
				case .changingSubscribingState:
					ProgressView()
						.frame(width: 15,height: 15)
						.padding(5)
				default:
					let contains = Model.shared.journeyFollowViewModel.state.journeys.contains(where: {$0.id == viewModel.state.data.id})
					Image(.bookmark)
						.symbolVariant(contains ? .fill : .none )
						.frame(width: 15,height: 15)
						.tint(viewModel.state.status.description == "loading" ? .chewGray30 : .blue)
						.padding(5)
				}
			}
		)
	}
}


extension JourneyDetailsView {
	func toolbar() -> some View {
		HStack {
			if #available(iOS 17.0, *) {
				follow()
					.popoverTip(ChooTips.followJourney, arrowEdge: .bottom)
			} else {
				follow()
			}
			Button(
				action: {
					viewModel.send(event: .didTapReloadButton(
						id: viewModel.state.data.id,
						ref: viewModel.state.data.viewData.refreshToken
					))
				},
				label: {
					switch viewModel.state.status {
					case .loading, .loadingIfNeeded:
						ProgressView()
							.frame(width: 15,height: 15)
							.padding(5)
					case .loadedJourneyData,
							.changingSubscribingState:
						Image(.arrowClockwise)
							.frame(width: 15,height: 15)
							.padding(5)
					case .error:
						Image(.exclamationmarkCircle)
							.frame(width: 15,height: 15)
							.padding(5)
					}
				}
			)
		}
	}
}
