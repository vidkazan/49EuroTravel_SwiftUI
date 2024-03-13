//
//  FavouriteRidesView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.10.23.
//

import Foundation
import SwiftUI
import CoreLocation

struct DepartureArrivalPair : Equatable, Hashable {
	let departure : Stop
	let arrival : Stop
	let id : String
	init(departure: Stop, arrival: Stop) {
		self.departure = departure
		self.arrival = arrival
		self.id = departure.name + arrival.name
	}
}

struct RecentSearchesView : View {
	@EnvironmentObject var chewVM : ChewViewModel
	@ObservedObject var recentSearchesVM : RecentSearchesViewModel = Model.shared.recentSearchesViewModel
	@State var searches : [RecentSearchesViewModel.RecentSearch] = []
	var body: some View {
		Group {
			if !recentSearchesVM.state.searches.isEmpty {
				VStack(alignment: .leading,spacing: 2) {
					Text(
						"Recent searches",
						comment: "RecentSearchesView: view name"
					)
					.chewTextSize(.big)
					.offset(x: 10)
					.foregroundColor(.secondary)
					ScrollView(.horizontal,showsIndicators: false) {
						HStack {
							ForEach(searches,id: \.searchTS) { locations in
								RecentSearchCell(
									send: recentSearchesVM.send,
									locations:locations.stops
								)
							}
						}
					}
				}
			}
		}
		.onReceive(recentSearchesVM.$state, perform: { state in
			Task {
				self.searches = Array(state.searches
					.sorted(by: {$0.searchTS > $1.searchTS}).prefix(5))
			}
		})
	}
}

