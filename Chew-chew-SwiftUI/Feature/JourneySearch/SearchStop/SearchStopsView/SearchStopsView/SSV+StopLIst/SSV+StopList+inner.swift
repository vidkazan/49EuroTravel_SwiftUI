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
						Group {
							Label(stop.0.name, systemImage: stop.0.type.SFSIcon)
						}
						.foregroundColor(.primary)
					})
					.padding(.leading,5)
					Spacer()
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
									HStack(alignment: .center) {
										Button(action: {
											if (searchStopViewModel.state.previousStops.first(where: {$0.id == stop.0.id}) == nil) {
												Model.shared.coreDataStore.addRecentLocation(stop: stop.0)
											}
											chewViewModel.send(event: .onNewStop(.location(stop.0), type))
											searchStopViewModel.send(event: .onStopDidTap(.location(stop.0), type))
										}, label: {
											Label(stop.0.name, systemImage: stop.0.type.SFSIcon)
											Spacer()
										})
										.frame(height: 40)
										.padding(.horizontal,5)
										.foregroundColor(.primary)
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
	func sortStopByLocation(stops : [Stop]) -> ([(Stop, Double?)]) {
		var res = [(Stop, Double)]()
		var resOptional = [(Stop, Double?)]()
		let tmp = stops
		if let location = Model.shared.locationDataManager.locationManager.location {
			res = tmp.map({stop in
				return (stop, location.distance(stop.coordinates))
			})
			res.sort(by: { $0.1 < $1.1 })
			resOptional = res
		} else {
			resOptional = tmp.map({ return ($0, nil)})
		}
		return resOptional
	}
}
