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
			VStack {
				HStack {
					BadgeView(.departureArrivalStops(departure: viewModel.state.data.origin, arrival: viewModel.state.data.destination),.big)
					Spacer()
				}
				HStack {
					BadgeView(.date(dateString: viewModel.state.data.timeContainer.stringDateValue.departure.actual ?? ""))
						.badgeBackgroundStyle(.accent)
					BadgeView(
						.timeDepartureTimeArrival(
							timeDeparture: viewModel.state.data.timeContainer.stringTimeValue.departure.actual ?? "time",
							timeArrival: viewModel.state.data.timeContainer.stringTimeValue.arrival.actual ?? "time"
						)
					)
						.badgeBackgroundStyle(.accent)
					BadgeView(.legDuration(dur: viewModel.state.data.durationLabelText))
						.badgeBackgroundStyle(.accent)
					if viewModel.state.data.transferCount > 0 {
						BadgeView(.changesCount(viewModel.state.data.transferCount))
							.badgeBackgroundStyle(.accent)
					}
					Spacer()
				}
				LegsView(journey : viewModel.state.data)
					.padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
			}
			
		}
	}
}
