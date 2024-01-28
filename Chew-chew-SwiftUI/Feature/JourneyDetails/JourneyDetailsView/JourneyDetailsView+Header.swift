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
					BadgeView(.departureArrivalStops(departure: data.viewData.origin, arrival: data.viewData.destination),.huge)
					Spacer()
				}
				HStack {
					BadgeView(.date(dateString: data.viewData.timeContainer.stringDateValue.departure.actual ?? ""))
						.badgeBackgroundStyle(.accent)
					BadgeView(
						.timeDepartureTimeArrival(
							timeDeparture: data.viewData.timeContainer.stringTimeValue.departure.actual ?? "",
							timeArrival: data.viewData.timeContainer.stringTimeValue.arrival.actual ?? ""
						)
					)
						.badgeBackgroundStyle(.accent)
					BadgeView(.legDuration(dur: data.viewData.durationLabelText))
						.badgeBackgroundStyle(.accent)
					if viewModel.state.data.viewData.transferCount > 0 {
						BadgeView(.changesCount(data.viewData.transferCount))
							.badgeBackgroundStyle(.accent)
					}
					Spacer()
				}
				LegsView(journey : viewModel.state.data.viewData,showProgressBar: true)
					.padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
			}
			
		}
	}
}
