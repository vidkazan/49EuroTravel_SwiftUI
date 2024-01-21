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
	@ObservedObject var recentSearchesVM : RecentSearchesViewModel
	init(recentSearchesVM : RecentSearchesViewModel) {
		self.recentSearchesVM = recentSearchesVM
	}
	var body: some View {
		if !recentSearchesVM.state.searches.isEmpty {
			VStack(alignment: .leading,spacing: 1) {
				Text("Recent searches")
					.chewTextSize(.big)
					.offset(x: 10)
					.foregroundColor(.secondary)
				ScrollView(.horizontal,showsIndicators: false) {
					LazyHStack {
						ForEach(recentSearchesVM.state.searches, id: \.hashValue) { locations in
							RecentSearchCell(send: recentSearchesVM.send, locations:locations)
								.onTapGesture {
									chewVM.send(event: .didSetBothLocations(locations.departure, locations.arrival))
								}
						}
						.background(Color.chewFillAccent)
						.cornerRadius(8)
					}
				}
				.padding(5)
				.background(Color.chewFillSecondary)
				.frame(maxWidth: .infinity,maxHeight: 100)
				.cornerRadius(10)
			}
			.transition(.opacity)
			.animation(.spring().speed(2), value: chewVM.state.status)
			.animation(.spring().speed(2), value: chewVM.searchStopsViewModel.state.status)
			.animation(.spring().speed(2), value: chewVM.recentSearchesViewModel.state.status)
		}
	}
}
