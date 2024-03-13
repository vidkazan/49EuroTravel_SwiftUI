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
				Color.chewFillGreenPrimary
					.frame(width: 10)
					.cornerRadius(4)
					.padding(5)
				VStack(alignment: .leading,spacing: 0) {
					Text(verbatim: locations.departure.name)
						.chewTextSize(.big)
						.padding(5)
					Spacer()
					Text(verbatim:  locations.arrival.name)
						.chewTextSize(.big)
						.padding(5)
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
			.padding(10)
			.background(Color.chewFillAccent.opacity(0.5))
			.frame(maxWidth: 250, maxHeight: 80)
			.clipShape(.rect(cornerRadius: 8))
	}
}

struct RecentSearchesPreviews: PreviewProvider {
	static var previews: some View {
		RecentSearchesView(
			recentSearchesVM: .init(
				searches: [
					.init(stops: .init(departure: .init(), arrival: .init()), searchTS: 0)
				]
			)
		)
		.environmentObject(ChewViewModel(referenceDate: .now))
	}
}
