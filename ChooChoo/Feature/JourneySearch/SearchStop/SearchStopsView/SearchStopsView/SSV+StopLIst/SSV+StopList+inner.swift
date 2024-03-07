//
//  SearchStopsView+StopList.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//

import CoreLocation
import Foundation
import SwiftUI

extension SearchStopsView {
	func recentStops(type : LocationDirectionType, recentStops : [(Stop,Double?)]) -> some View {
		Group {
			if !recentStops.isEmpty {
			Divider()
			ForEach(recentStops,id: \.1) { stop in
				HStack(alignment: .center) {
					Button(action: {
						chewViewModel.send(event: .onNewStop(.location(stop.0), type))
						searchStopViewModel.send(event: .onStopDidTap(.location(stop.0), type))
					}, label: {
						stopListCell(stop: stop)
					})
					.foregroundColor(.primary)
					.padding(.leading,5)
					Button(action: {
						if (searchStopViewModel.state.previousStops.first(where: {$0.name == stop.0.name}) != nil),
						   Model.shared.coreDataStore.deleteRecentLocationIfFound(name: stop.0.name) != false {
							searchStopViewModel.send(event: .didRequestDeleteRecentStop(stop: stop.0))
						}
					}, label: {
						Image(.xmarkCircle)
							.foregroundColor(.primary)
							.chewTextSize(.big)
					})
					.frame(height: 40)
					Image(.clockArrowCirclepath)
						.chewTextSize(.big)
						.foregroundColor(.chewGrayScale30)
						.padding(.horizontal,7)
						.frame(height: 40)
						.foregroundColor(.primary)
				}
			}
			}
		}
	}
}

extension SearchStopsView {
	func foundStop(type : LocationDirectionType,stops : [(Stop,Double?)]) -> some View {
		return Group {
			switch searchStopViewModel.state.status {
			case .loaded,.updatingRecentStops:
				VStack {
					Divider()
					ScrollView {
						if !searchStopViewModel.state.stops.isEmpty {
							VStack(spacing: 0) {
								ForEach(stops,id:\.0) { stop in
									HStack(alignment: .center, spacing: 1) {
										Button(
											action: {
												if (searchStopViewModel.state.previousStops.first(where: {$0.id == stop.0.id}) == nil) {
													Model.shared.coreDataStore.addRecentLocation(stop: stop.0)
												}
												chewViewModel.send(event: .onNewStop(.location(stop.0), type))
												searchStopViewModel.send(event: .onStopDidTap(.location(stop.0), type))
											},
											label: {
												stopListCell(stop: stop)
										})
										.frame(height: 40)
										Spacer()
										if let dist = stop.1 {
											BadgeView(.distanceInMeters(dist: dist))
												.badgeBackgroundStyle(.primary)
										}
									}
								}
							}
						}
					}
				}
				.frame(maxHeight: 300)
			case .error(let error):
				Text(error.description)
					.chewTextSize(.big)
					.foregroundColor(.secondary)
					.padding(5)
					.frame(maxWidth: .infinity,alignment: .center)
			case .idle, .loading:
				EmptyView()
			}
		}
	}
}

extension SearchStopsView {
	func stopListCell(stop : (Stop, Double?)) -> some View {
		Group {
			if let lineType = stop.0.stopDTO?.products?.lineType,
				let icon = lineType.icon {
				Label {
					Text(stop.0.name)
						.foregroundColor(.primary)
				} icon: {
					Image(icon)
						.padding(5)
						.aspectRatio(1, contentMode: .fill)
						.badgeBackgroundStyle(BadgeBackgroundBaseStyle(lineType.color))
				}
				.chewTextSize(.big)
			} else {
				Label(stop.0.name, systemImage: stop.0.type.SFSIcon)
					.chewTextSize(.big)
					.foregroundColor(.primary)
			}
		}
		.frame(maxWidth: .infinity,alignment: .leading)
		.foregroundColor(.primary)
	}
}
