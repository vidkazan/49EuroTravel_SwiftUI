//
//  FavouriteRideCell.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.10.23.
//

import Foundation
import SwiftUI

struct FavouriteRideCell: View {
	let locations : Locations
	var body: some View {
		HStack(spacing: 0) {
			Color.chewGreenScale20
				.frame(width: 10)
				.cornerRadius(4)
				.padding(5)
			VStack(alignment: .leading) {
				Text(locations.departure.stop.name ?? locations.departure.stop.address ?? "Origin")
					.chewTextSize(.medium)
					.padding(5)
				Spacer()
				Text(locations.arrival.stop.name ?? locations.arrival.stop.address ?? "Destination")
					.chewTextSize(.medium)
					.padding(5)
			}
		}
	}
}
