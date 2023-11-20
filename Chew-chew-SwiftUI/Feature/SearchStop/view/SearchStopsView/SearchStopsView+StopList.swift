//
//  SearchStopsView+StopList.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//

import Foundation
import SwiftUI

extension SearchStopsView {
	func stopList(type : LocationDirectionType) -> some View {
		return VStack {
			ForEach(searchStopViewModel.state.previousStops) { stop in
				HStack(alignment: .center) {
					Button(action: {
						switch type {
						case .departure:
							chewViewModel.send(event: .onNewDeparture(stop))
							searchStopViewModel.send(event: .onStopDidTap(stop, type))
						case .arrival:
							chewViewModel.send(event: .onNewArrival(stop))
							searchStopViewModel.send(event: .onStopDidTap(stop, type))
						}
						Location.createWith(stop: stop, using: viewContext)
					}, label: {
						switch stop.type {
						case .stop:
							Label(stop.name, systemImage: "train.side.front.car")
						case .pointOfInterest:
							Label(stop.name, systemImage: "building.2.crop.circle")
						case .location:
							Label(stop.name, systemImage: "building.2.crop.circle.fill")
						}
					})
					.frame(height: 35)
					.padding(.horizontal,5)
					.foregroundColor(.primary)
					Spacer()
				}
			}
			switch searchStopViewModel.state.status {
			case .loaded,.updatingRecentStops:
				if searchStopViewModel.state.previousStops.count > 0,
				   searchStopViewModel.state.stops.count > 0 {
					Divider()
				}
				ScrollView {
					if !searchStopViewModel.state.stops.isEmpty {
						ForEach(searchStopViewModel.state.stops) { stop in
							HStack(alignment: .center) {
								Button(action: {
									switch type {
									case .departure:
										chewViewModel.send(event: .onNewDeparture(stop))
										searchStopViewModel.send(event: .onStopDidTap(stop, type))
									case .arrival:
										chewViewModel.send(event: .onNewArrival(stop))
										searchStopViewModel.send(event: .onStopDidTap(stop, type))
									}
									Location.createWith(stop: stop, using: viewContext)
								}, label: {
									switch stop.type {
									case .stop:
										Label(stop.name, systemImage: "train.side.front.car")
									case .pointOfInterest:
										Label(stop.name, systemImage: "building.2.crop.circle")
									case .location:
										Label(stop.name, systemImage: "building.2.crop.circle.fill")
									}
								})
								.frame(height: 35)
								.padding(.horizontal,5)
								.foregroundColor(.primary)
								Spacer()
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
