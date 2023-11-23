//
//  FavouriteRidesView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.10.23.
//

import Foundation
import SwiftUI
import CoreLocation

struct DepartureArrivalPair : Identifiable {
	let id = UUID()
	let departure : Stop
	let arrival : Stop
}

struct FavouriteRidesView : View {
	@EnvironmentObject var chewVM : ChewViewModel
	let stops : [DepartureArrivalPair]
	init() {
		self.stops = [
			DepartureArrivalPair(
				departure: Stop(
					coordinates: CLLocationCoordinate2D(latitude: 51.2, longitude: 6.7),
					type: .location,
					stopDTO: nil
				),
				arrival: Stop(
					coordinates: CLLocationCoordinate2D(latitude: 52, longitude: 10),
					type: .stop,
					stopDTO: StopDTO(
						type: "station",
						id: "\(8089222)",
						name: "Wolfsburg ZOB",
						address: nil,
						location: nil,
						latitude: nil,
						longitude: nil,
						poi: false,
						products: nil
					)
				)
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
		.animation(.spring().speed(2), value: chewVM.state.status)
		.animation(.spring().speed(2), value: chewVM.searchStopsViewModel.state.status)
	}
}


