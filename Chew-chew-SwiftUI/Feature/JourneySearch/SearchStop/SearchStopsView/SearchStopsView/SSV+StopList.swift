//
//  SearchStopsView+StopList.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//

import CoreLocation
import Foundation
import SwiftUI

extension CLLocation {
	func distance(_ from : CLLocationCoordinate2D) -> CLLocationDistance {
		return self.distance(from: CLLocation(latitude: from.latitude, longitude: from.longitude))
	}
}

extension SearchStopsView {
	func sortStopByLocation(stops : [Stop]) -> ([(Stop, Int?)]) {
		var res = [(Stop, Int)]()
		var resOptional = [(Stop, Int?)]()
		let tmp = stops
		if let location = Model.shared.locationDataManager.locationManager.location {
			res = tmp.map({stop in
				return (stop, Int(location.distance(stop.coordinates)))
			})
			res.sort(by: { $0.1 < $1.1 })
			resOptional = res
		} else {
			resOptional = tmp.map({ return ($0, nil)})
		}
		return resOptional
	}
	
	func stopList(type : LocationDirectionType) -> some View {
		let recentStopsAll = searchStopViewModel.state.previousStops.filter { stop in
			switch type {
			   case .departure:
				   return stop.name.hasPrefix(topText)
			   case .arrival:
				   return stop.name.hasPrefix(bottomText)
			   }
		}
		let recentStops = Array(sortStopByLocation(stops: recentStopsAll).prefix(2))
		let stops = sortStopByLocation(stops: searchStopViewModel.state.stops)
		return VStack(alignment: .leading,spacing: 0) {
			Button(action: {
				chewViewModel.send(event: .didCancelEditStop)
				Model.shared.sheetViewModel.send(event: .didRequestShow(.mapPicker(type: type)))
			}, label: {
				Label("find on map", systemImage: "map.circle")
			})
			.foregroundColor(.primary)
			.padding(.leading,5)
			.frame(height: 40,alignment: .leading)
			Divider()
			ForEach(recentStops,id: \.1) { stop in
				HStack(alignment: .center) {
					Button(action: {
						chewViewModel.send(event: .onNewStop(.location(stop.0), type))
						searchStopViewModel.send(event: .onStopDidTap(.location(stop.0), type))
					}, label: {
						Group {
							switch stop.0.type {
							case .stop:
								Label(stop.0.name, systemImage: ChewSFSymbols.trainSideFrontCar.rawValue)
							case .pointOfInterest:
								Label(stop.0.name, systemImage: ChewSFSymbols.building2CropCircle.rawValue)
							case .location:
								Label(stop.0.name, systemImage: ChewSFSymbols.building2CropCircle.fill.rawValue)
							}
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
			switch searchStopViewModel.state.status {
			case .loaded,.updatingRecentStops:
				if !recentStops.isEmpty,
				   !searchStopViewModel.state.stops.isEmpty {
					Divider()
				}
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
										switch stop.0.type {
										case .stop:
											Label(stop.0.name, systemImage: "train.side.front.car")
										case .pointOfInterest:
											Label(stop.0.name, systemImage: "building.2.crop.circle")
										case .location:
											Label(stop.0.name, systemImage: "building.2.crop.circle.fill")
										}
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
		.padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
		.frame(maxWidth: .infinity,alignment: .leading)
	}
}
