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
		let recentStops = searchStopViewModel.state.previousStops.filter { stop in
			switch type {
			   case .departure:
				   return stop.name.hasPrefix(topText)
			   case .arrival:
				   return stop.name.hasPrefix(bottomText)
			   }
		   }.prefix(2)
		return VStack {
			ForEach(recentStops) { stop in
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
				if !recentStops.isEmpty,
				   !searchStopViewModel.state.stops.isEmpty {
					Divider()
				}
				ScrollView {
					if !searchStopViewModel.state.stops.isEmpty {
						ForEach(searchStopViewModel.state.stops) { stop in
							HStack(alignment: .center) {
								Button(action: {
									if !searchStopViewModel.state.previousStops.contains(stop) {
										Location.createWith(user: chewViewModel.user,stop: stop, using: viewContext)
									}
									switch type {
									case .departure:
										chewViewModel.send(event: .onNewDeparture(stop))
										searchStopViewModel.send(event: .onStopDidTap(stop, type))
									case .arrival:
										chewViewModel.send(event: .onNewArrival(stop))
										searchStopViewModel.send(event: .onStopDidTap(stop, type))
									}
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
