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
			VStack(alignment: .leading) {
				BadgeView(
					.departureArrivalStops(
						departure: data.viewData.origin,
						arrival: data.viewData.destination
					),
					.huge
				)
				if #available(iOS 16.0, *) {
					FlowLayout(spacing: CGSize(width: 5, height: 2)) {
						if let date = data.viewData.time.date.departure.actualOrPlannedIfActualIsNil() {
							BadgeView(.date(date: date))
								.badgeBackgroundStyle(.accent)
						}
						BadgeView(.timeDepartureTimeArrival(timeContainer: data.viewData.time))
							.badgeBackgroundStyle(.accent)
						BadgeView(.legDuration(data.viewData.time))
							.badgeBackgroundStyle(.accent)
						if viewModel.state.data.viewData.transferCount > 0 {
							BadgeView(.changesCount(data.viewData.transferCount))
								.badgeBackgroundStyle(.accent)
						}
					}
				} else {
					HStack {
						if let date = data.viewData.time.date.departure.actualOrPlannedIfActualIsNil() {
							BadgeView(.date(date: date))
								.badgeBackgroundStyle(.accent)
						}
						BadgeView(
							.timeDepartureTimeArrival(
								timeContainer: data.viewData.time
							)
						)
						.badgeBackgroundStyle(.accent)
						BadgeView(
							.legDuration(data.viewData.time)
						)
						.badgeBackgroundStyle(.accent)
						if viewModel.state.data.viewData.transferCount > 0 {
							BadgeView(
								.changesCount(
									data.viewData.transferCount
								)
							)
							.badgeBackgroundStyle(.accent)
						}
						Spacer()
					}
				}
				LegsView(
					journey : viewModel.state.data.viewData,
					progressBar: true,
					mode : chewVM.state.settings.legViewMode
				)
			}
			
		}
	}
}
