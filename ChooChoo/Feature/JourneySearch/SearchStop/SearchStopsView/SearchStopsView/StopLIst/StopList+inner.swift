//
//  SearchStopsView+StopList.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//

import CoreLocation
import Foundation
import SwiftUI

extension StopList {
	func recentStops(
		type : LocationDirectionType,
		recentStops : [StopWithDistance]
	) -> some View {
		Group {
			if !recentStops.isEmpty {
				Divider()
				ForEach(recentStops,id: \.distance) { stop in
					HStack(alignment: .center) {
						Button(action: {
							chewViewModel.send(event: .onNewStop(.location(stop.stop), type))
							searchStopViewModel.send(event: .onStopDidTap(.location(stop.stop), type))
						}, label: {
							stopListCell(stop: stop)
						})
						.foregroundColor(.primary)
						.padding(.leading,5)
						Button(action: {
							if (searchStopViewModel.state.previousStops.first(where: {$0.name == stop.stop.name}) != nil),
							   Model.shared.coreDataStore.deleteRecentLocationIfFound(name: stop.stop.name) != false {
								searchStopViewModel.send(event: .didRequestDeleteRecentStop(stop: stop.stop))
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

extension StopList {
	func foundStop(type : LocationDirectionType,stops : [StopWithDistance]) -> some View {
		return Group {
			switch searchStopViewModel.state.status {
			case .loaded,.updatingRecentStops:
				VStack {
					Divider()
					ScrollView {
						if !searchStopViewModel.state.stops.isEmpty {
							VStack(spacing: 0) {
								ForEach(stops,id:\.distance) { stop in
									HStack(alignment: .center, spacing: 1) {
										Button(
											action: {
												Task {
													if (searchStopViewModel.state.previousStops.first(where: {$0.id == stop.stop.id}) == nil) {
														Model.shared.coreDataStore.addRecentLocation(stop: stop.stop)
													}
													chewViewModel.send(event: .onNewStop(.location(stop.stop), type))
													searchStopViewModel.send(event: .onStopDidTap(.location(stop.stop), type))
												}
											},
											label: {
												stopListCell(stop: stop)
										})
										.frame(height: 40)
										Spacer()
										if let dist = stop.distance {
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

extension StopList {
	func stopListCell(stop : StopWithDistance) -> some View {
		Group {
			if let lineType = stop.stop.stopDTO?.products?.lineType,
				let icon = lineType.icon {
				Label {
					Text(verbatim: stop.stop.name)
						.foregroundColor(.primary)
				} icon: {
					Image(icon)
						.padding(5)
						.aspectRatio(1, contentMode: .fill)
						.badgeBackgroundStyle(BadgeBackgroundBaseStyle(lineType.color))
				}
				.chewTextSize(.big)
			} else {
				Label(stop.stop.name, systemImage: stop.stop.type.SFSIcon)
					.chewTextSize(.big)
					.foregroundColor(.primary)
			}
		}
		.frame(maxWidth: .infinity,alignment: .leading)
		.foregroundColor(.primary)
	}
}
