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
		return VStack(spacing: 0) {
			ForEach(recentStops) { stop in
				HStack(alignment: .center) {
					Button(action: {
						chewViewModel.send(event: .onNewStop(.location(stop), type))
						searchStopViewModel.send(event: .onStopDidTap(.location(stop), type))
					}, label: {
						switch stop.type {
						case .stop:
							Label(stop.name, systemImage: ChewSFSymbols.trainSideFrontCar.rawValue)
						case .pointOfInterest:
							Label(stop.name, systemImage: ChewSFSymbols.building2CropCircle.rawValue)
						case .location:
							Label(stop.name, systemImage: ChewSFSymbols.building2CropCircle.fill.rawValue)
						}
						Spacer()
						Image(.clockArrowCirclepath)
							.foregroundColor(.chewGrayScale30)
							.padding(.horizontal,7)
					})
					.frame(height: 40)
					.padding(.leading,5)
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
							ForEach(searchStopViewModel.state.stops) { stop in
								HStack(alignment: .center) {
									Button(action: {
										if (searchStopViewModel.state.previousStops.first(where: { elem in
												elem.name == stop.name
											}) == nil
										) {
											chewViewModel.coreDataStore.addRecentLocation(stop: stop)
										}
										chewViewModel.send(event: .onNewStop(.location(stop), type))
										searchStopViewModel.send(event: .onStopDidTap(.location(stop), type))
									}, label: {
										switch stop.type {
										case .stop:
											Label(stop.name, systemImage: "train.side.front.car")
										case .pointOfInterest:
											Label(stop.name, systemImage: "building.2.crop.circle")
										case .location:
											Label(stop.name, systemImage: "building.2.crop.circle.fill")
										}
										Spacer()
									})
									.frame(height: 40)
									.padding(.horizontal,5)
									.foregroundColor(.primary)
									Spacer()
								}
							}
						}
					}
				}
				.frame(idealHeight: 300)
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
