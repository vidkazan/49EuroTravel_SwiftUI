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
		VStack(alignment: .leading,spacing: 1) {
//			findOnMap(type: type)
			recentStops(type: type,recentStops: recentStopsData)
			foundStop(type: type, stops: stops)
		}
		.onReceive(searchStopViewModel.$state, perform: { _ in
			Task { update(type : type) }
		})
		.onChange(of: type == .departure ? topText : bottomText, perform: { value in
			Task { update(type : type) }
		})
		.padding(.horizontal,5)
		.frame(maxWidth: .infinity,alignment: .leading)
	}
}

extension SearchStopsView {
	func update(type : LocationDirectionType) {
		stops = SearchStopsViewModel.sortedStopsByLocationWithDistance(stops: searchStopViewModel.state.stops)
		let recentStopsAll = searchStopViewModel.state.previousStops.filter { stop in
			return stop.name.hasPrefix(type == .departure ? topText : bottomText )
		}
		recentStopsData = Array(
			SearchStopsViewModel.sortedStopsByLocationWithDistance(stops: recentStopsAll).prefix(2)
		)
	}
}
