//
//  JourneyDetails.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.09.23.
//

import SwiftUI

extension JourneyDetailsView {
	func header() -> some View {
		VStack(alignment: .leading) {
			let data = viewModel.state.data
			VStack {
				HStack {
					BadgeView(.departureArrivalStops(departure: data.origin, arrival: data.destination),.huge)
					Spacer()
				}
				HStack {
					BadgeView(.date(dateString: data.timeContainer.stringDateValue.departure.actual ?? ""))
						.badgeBackgroundStyle(.accent)
					BadgeView(
						.timeDepartureTimeArrival(
							timeDeparture: data.timeContainer.stringTimeValue.departure.actual ?? "",
							timeArrival: data.timeContainer.stringTimeValue.arrival.actual ?? ""
						)
					)
						.badgeBackgroundStyle(.accent)
					BadgeView(.legDuration(dur: data.durationLabelText))
						.badgeBackgroundStyle(.accent)
					if viewModel.state.data.transferCount > 0 {
						BadgeView(.changesCount(data.transferCount))
							.badgeBackgroundStyle(.accent)
					}
					Spacer()
				}
				LegsView(journey : viewModel.state.data,showProgressBar: true)
					.padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
			}
			
		}
	}
}
