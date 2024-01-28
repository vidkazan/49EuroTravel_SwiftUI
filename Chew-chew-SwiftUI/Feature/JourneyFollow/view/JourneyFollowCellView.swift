 //
//  JourneyFollowCellView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 16.12.23.
//

import Foundation
import SwiftUI

struct JourneyFollowCellView : View {
	@EnvironmentObject var chewVM : ChewViewModel
	@ObservedObject var vm : JourneyDetailsViewModel
	@State var isLoading : Bool = false
	init(journeyDetailsViewModel: JourneyDetailsViewModel) {
		self.vm = journeyDetailsViewModel
	}
	var body: some View {
		VStack(alignment: .leading) {
			let data = vm.state.data.viewData
			HStack {
				NavigationLink(destination: {
					JourneyDetailsView(journeyDetailsViewModel: vm)
				}, label: {
					Text(data.legs.first?.legStopsViewData.first?.name ?? "origin")
						.chewTextSize(.big)
					Image(systemName: "arrow.right")
					Text(data.legs.last?.legStopsViewData.last?.name ?? "destination")
						.chewTextSize(.big)
					Spacer()
				})
			}
			HStack {
				BadgeView(
					.date(dateString: data.timeContainer.stringDateValue.departure.actual ?? "date"),
					color: Color.chewFillTertiary.opacity(0.3)
				)
				.badgeBackgroundStyle(.secondary)
				BadgeView(
					.timeDepartureTimeArrival(
						timeDeparture: data.timeContainer.stringTimeValue.departure.actual ?? "time",
						timeArrival: data.timeContainer.stringTimeValue.arrival.actual ?? "time"),
					color: Color.chewFillTertiary.opacity(0.3)
				)
				.badgeBackgroundStyle(.secondary)
				BadgeView(
					.legDuration(dur: data.durationLabelText),
					color: Color.chewFillTertiary.opacity(0.3)
				)
				.badgeBackgroundStyle(.secondary)
			}
			
			LegsView(journey : data,showProgressBar: true)
			BadgeView(
				.updatedAtTime(
					referenceTime: data.updatedAt,
					isLoading: isLoading
				),
				color: Color.chewFillTertiary
			)
			.badgeBackgroundStyle(.secondary)
		}
		.onReceive(vm.$state, perform: { state in
			switch state.status {
			case .loading,.loadingIfNeeded:
				isLoading = true
			default:
				isLoading = false
			}
			
		})
//		.onChange(of: vm.state.status, perform: { status in
//
//		})
		.onAppear {
			if let token = vm.state.data.viewData.refreshToken {
				vm.send(event: .didRequestReloadIfNeeded(ref: token))
			}
		}
	}
}
