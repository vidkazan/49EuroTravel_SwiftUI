//
//  FavouriteRideCell.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.10.23.
//

import Foundation
import SwiftUI

struct FavouriteRideCell: View {
	let locations : DepartureArrivalPair
	var body: some View {
		HStack(spacing: 0) {
			Color.chewGreenScale20
				.frame(width: 10)
				.cornerRadius(4)
				.padding(5)
			VStack(alignment: .leading) {
				Text(locations.departure.name)
					.chewTextSize(.medium)
					.padding(5)
				Spacer()
				Text(locations.arrival.name)
					.chewTextSize(.medium)
					.padding(5)
			}
		}
	}
}
