//
//  FavouriteRidesView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.10.23.
//

import Foundation
import SwiftUI

struct Locations : Identifiable {
	let id = UUID()
	let departure : StopType
	let arrival : StopType
}

struct FavouriteRidesView : View {
	@EnvironmentObject var chewVM : ChewViewModel
	let stops : [Locations]
	init() {
		self.stops = [
			Locations(
				departure: StopType.stop(Stop(type: "station", id: "\(586640)", name: "Zolltor,Neuss", address: nil, location: nil, products: nil)),
				arrival: StopType.stop(Stop(type: "station", id: "\(8089222)", name: "Wolfsburg ZOB", address: nil, location: nil, products: nil))
			)
		]
	}
	var body: some View {
		VStack(alignment: .leading,spacing: 1) {
			Text("Favorite journeys")
				.chewTextSize(.medium)
				.offset(x: 10)
				.foregroundColor(.secondary)
			ScrollView(.horizontal) {
				LazyHStack(spacing: 2) {
					ForEach(stops) { locations in
						FavouriteRideCell(locations:locations)
						.onTapGesture {
							chewVM.send(event: .didSetBothLocations(locations.departure, locations.arrival))
						}
					}
					.padding(10)
					.background(Color.chewGrayScale10)
					.cornerRadius(8)
				}
			}
			.padding(5)
			.background(Color.chewGray10)
			.frame(maxWidth: .infinity,maxHeight: 100)
			.cornerRadius(10)
		}
		.transition(.opacity)
		.animation(.spring(), value: chewVM.state.status)
//		.animation(.spring(), value: chewVM.state.searchStopViewModel.state)
	}
}


