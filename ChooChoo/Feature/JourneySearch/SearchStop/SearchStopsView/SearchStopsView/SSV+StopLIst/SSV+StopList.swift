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
	
	func stopList(type : LocationDirectionType) -> some View {
		let recentStopsAll = searchStopViewModel.state.previousStops.filter { stop in
			return type == .departure ? stop.name.hasPrefix(topText) : stop.name.hasPrefix(bottomText)
		}
		let recentStopsData = Array(
			SearchStopsViewModel
				.sortedStopsByLocationWithDistance(stops: recentStopsAll).prefix(2)
		)
		let stops = SearchStopsViewModel
			.sortedStopsByLocationWithDistance(stops: searchStopViewModel.state.stops)
		return VStack(alignment: .leading,spacing: 1) {
			findOnMap(type: type)
			recentStops(type: type,recentStops: recentStopsData)
			foundStop(type: type, stops: stops)
		}
		.padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
		.frame(maxWidth: .infinity,alignment: .leading)
	}
}

extension SearchStopsView {
	func findOnMap(type : LocationDirectionType) -> some View {
		return Button(action: {
			chewViewModel.send(event: .didCancelEditStop)
			Model.shared.sheetViewModel.send(event: .didRequestShow(.mapPicker(type: type)))
		}, label: {
			Label("find on map", systemImage: "map.circle")
				.chewTextSize(.big)
		})
		.foregroundColor(.primary)
		.padding(.leading,5)
		.frame(maxWidth: .infinity,minHeight: 40,alignment: .leading)
	}
}
