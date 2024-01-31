//
//  JourneyDetails.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.09.23.
//

import SwiftUI
import MapKit

extension JourneyDetailsView {
	func toolbar() -> some View {
		HStack {
			Button(
				action: {
					switch viewModel.state.status {
					case .loading:
						break
					default:
						viewModel.send(
							event: .didTapSubscribingButton(ref: viewModel.state.data.viewData.refreshToken, journeyDetailsViewModel: viewModel))
					}
				},
				label: {
					switch viewModel.state.status {
					case .changingSubscribingState:
						ProgressView()
							.frame(width: 15,height: 15)
							.padding(5)
					default:
						switch viewModel.state.data.isFollowed {
						case true:
							Image(.bookmark.fill)
								.frame(width: 15,height: 15)
								.tint(viewModel.state.status == .loading(token: viewModel.state.data.viewData.refreshToken) ? .chewGray30 : .blue)
								.padding(5)
						case false:
							Image(.bookmark)
								.tint(viewModel.state.status == .loading(token: viewModel.state.data.viewData.refreshToken) ? .chewGray30 : .blue)
								.frame(width: 15,height: 15)
								.padding(5)
							}
						}
					}
				)
			Button(
				action: {
					viewModel.send(event: .didTapReloadButton(ref: viewModel.state.data.viewData.refreshToken))
					
				},
				label: {
					switch viewModel.state.status {
					case .loading, .loadingIfNeeded:
						ProgressView()
							.frame(width: 15,height: 15)
							.padding(5)
					case .loadedJourneyData,
							.locationDetails,
							.loadingLocationDetails,
							.actionSheet,
							.fullLeg,
							.loadingFullLeg,
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
