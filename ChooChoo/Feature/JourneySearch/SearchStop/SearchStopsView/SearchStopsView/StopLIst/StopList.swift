//
//  SearchStopsView+StopList.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//

import CoreLocation
import Foundation
import SwiftUI

struct StopList : View {
	@Namespace var stopListNamespace
	@EnvironmentObject  var chewViewModel : ChewViewModel
	@ObservedObject var searchStopViewModel : SearchStopsViewModel = Model.shared.searchStopsViewModel
	@State var recentStopsData = [StopWithDistance]()
	@State var stops = [StopWithDistance]()
	
	var fieldText : String
	let type : LocationDirectionType
	var body: some View {
		VStack(alignment: .leading,spacing: 1) {
			findOnMap(type: type)
			recentStops(type: type,recentStops: recentStopsData)
			foundStop(type: type, stops: stops)
		}
		.onReceive(searchStopViewModel.$state, perform: { state in
			Task {
				stops = SearchStopsViewModel.sortedStopsByLocationWithDistance(stops: searchStopViewModel.state.stops)
				let recentStopsAll = searchStopViewModel.state.previousStops.filter { stop in
					return stop.name.hasPrefix(fieldText)
				}
				recentStopsData = Array(
					SearchStopsViewModel.sortedStopsByLocationWithDistance(stops: recentStopsAll).prefix(2)
				)
			}
		})
		.padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
		.frame(maxWidth: .infinity,alignment: .leading)
	}
}

extension StopList {
	func findOnMap(type : LocationDirectionType) -> some View {
		return Button(action: {
			chewViewModel.send(event: .didCancelEditStop)
			Model.shared.sheetViewModel.send(event: .didRequestShow(.mapPicker(type: type)))
		}, label: {
			Label(
				title: {
					Text(
						"find on map", 
						 comment : "SearchStopsView: button"
					)
				},
				icon: {
					Image(systemName: "map.circle")
				}
			)
				.chewTextSize(.big)
		})
		.foregroundColor(.primary)
		.padding(.leading,5)
		.frame(maxWidth: .infinity,minHeight: 40,alignment: .leading)
	}
}
