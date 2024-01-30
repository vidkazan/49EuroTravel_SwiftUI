//
//  FavouriteRideCell.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.10.23.
//

import Foundation
import SwiftUI

struct RecentSearchCell: View {
	let send : (RecentSearchesViewModel.Event) -> Void
	let locations : DepartureArrivalPair
	var body: some View {
			HStack(alignment: .top,spacing: 0) {
				Color.chewFillGreenPrimary
					.frame(width: 10)
					.cornerRadius(4)
					.padding(5)
				VStack(alignment: .leading) {
					Text(locations.departure.name)
						.chewTextSize(.big)
						.padding(5)
					Spacer()
					Text(locations.arrival.name)
						.chewTextSize(.big)
						.padding(5)
				}
				Button(action: {
					send(.didTapEdit(action: .deleting, search: locations))
				}, label: {
					Image(systemName: "xmark.circle")
						.chewTextSize(.big)
						.tint(.gray)
				})
				.frame(width: 25,height: 25)
				.background(Color.chewFillAccent.opacity(0.3))
				.cornerRadius(20)
			}
			.background(Color.clear)
			.padding(10)
	}
}

struct RecentSearchesPreviews: PreviewProvider {
	static var previews: some View {
		RecentSearchesView(
			recentSearchesVM: .init(
				coreDataStore: .init(),
				searches: [
					.init(
						departure: .init(),
						arrival: .init()
					)
				]
			)
		)
		.environmentObject(ChewViewModel())
	}
}
