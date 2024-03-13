//
//  FavouriteRideCell.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.10.23.
//

import Foundation
import SwiftUI

struct RecentSearchCell: View {
	@EnvironmentObject var chewVM : ChewViewModel
	let send : (RecentSearchesViewModel.Event) -> Void
	let locations : DepartureArrivalPair
	var body: some View {
			HStack(alignment: .top,spacing: 0) {
//				Color.chewFillGreenPrimary
//					.frame(width: 10)
//					.cornerRadius(4)
//					.padding(5)
				VStack(alignment: .leading,spacing: 0) {
					StopListCell(stop: locations.departure)
					StopListCell(stop: locations.arrival)
				}
				Button(action: {
					send(.didTapEdit(
						action: .deleting,
						search: RecentSearchesViewModel.RecentSearch(
							stops: locations,
							searchTS: Date.now.timeIntervalSince1970
						)
					))
				}, label: {
					Image(.xmarkCircle)
						.chewTextSize(.big)
						.tint(.gray)
				})
				.frame(width: 25,height: 25)
				.background(Color.chewFillAccent.opacity(0.3))
				.cornerRadius(20)
			}
			.onTapGesture {
				chewVM.send(event: .didSetBothLocations(locations,date: nil))
			}
			.frame(maxWidth: 250, maxHeight: 55)
			.padding(10)
			.background(Color.chewFillAccent.opacity(0.5))
			.clipShape(.rect(cornerRadius: 8))
	}
}

struct RecentSearchesPreviews: PreviewProvider {
	static var previews: some View {
		RecentSearchesView(
			recentSearchesVM: .init(
				searches: [
					.init(
						stops: .init(
							departure: .init(coordinates: .init(), type: .location, stopDTO: .init(
								name: "blafdvefvvfvdcvgvfdcvfdfvdcdccdcd dcdc dcdc",
								products: .init(bus: true)
							)),
							arrival: .init()),
						searchTS: 0
					)
				]
			)
		)
		.padding()
		.background(.chewFillTertiary)
		.environmentObject(ChewViewModel(referenceDate: .now))
	}
}
