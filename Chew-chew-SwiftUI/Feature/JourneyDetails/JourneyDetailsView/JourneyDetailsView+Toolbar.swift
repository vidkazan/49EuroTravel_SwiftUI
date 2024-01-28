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
			switch viewModel.state.data.viewData.refreshToken {
			case .none:
				Image(systemName: "bookmark.slash")
					.frame(width: 15,height: 15)
					.padding(5)
					.tint(.gray)
			case .some(let ref):
				Button(
					action: {
						switch viewModel.state.status {
						case .loading:
							break
						default:
							viewModel.send(event: .didTapSubscribingButton(ref: ref, journeyDetailsViewModel: viewModel))
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
								Image(systemName: "bookmark.fill")
									.frame(width: 15,height: 15)
									.tint(viewModel.state.status == .loading(token: ref) ? .chewGray30 : .blue)
									.padding(5)
							case false:
								Image(systemName: "bookmark")
									.tint(viewModel.state.status == .loading(token: ref) ? .chewGray30 : .blue)
									.frame(width: 15,height: 15)
									.padding(5)
							}
						}
					}
				)
			}
			Button(
				action: {
					guard let token = viewModel.state.data.viewData.refreshToken else {
						return viewModel.send(event: .didFailedToLoadJourneyData(error: JourneyDetailsViewModel.Error.inputValIsNil("refreshToken")))
					}
					viewModel.send(event: .didTapReloadButton(ref: token))
					
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
						Image(systemName: "arrow.clockwise")
							.frame(width: 15,height: 15)
							.padding(5)
					case .error:
						Image(systemName: "exclamationmark.circle")
							.frame(width: 15,height: 15)
							.padding(5)
					}
				}
			)
		}

	}
}
