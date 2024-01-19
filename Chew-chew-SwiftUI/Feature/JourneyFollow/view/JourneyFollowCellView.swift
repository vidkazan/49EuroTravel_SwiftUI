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
	init(journeyDetailsViewModel: JourneyDetailsViewModel) {
		self.vm = journeyDetailsViewModel
	}
	var body: some View {
		VStack(alignment: .leading) {
			HStack {
				Text(vm.state.data.legs.first?.legStopsViewData.first?.name ?? "origin")
					.chewTextSize(.big)
				Image(systemName: "arrow.right")
				Text(vm.state.data.legs.last?.legStopsViewData.last?.name ?? "destination")
					.chewTextSize(.big)
				Spacer()
				switch vm.state.status {
				case .loading,.loadingIfNeeded:
					ProgressView()
				default:
					EmptyView()
				}
			}
			HStack {
				BadgeView(
					.date(dateString: vm.state.data.timeContainer.stringDateValue.departure.actual ?? "date"),
					color: Color.chewFillTertiary.opacity(0.3)
				)
				.badgeBackgroundStyle(.secondary)
				BadgeView(
					.timeDepartureTimeArrival(
						timeDeparture: vm.state.data.timeContainer.stringTimeValue.departure.actual ?? "time",
						timeArrival: vm.state.data.timeContainer.stringTimeValue.arrival.actual ?? "time"),
					color: Color.chewFillTertiary.opacity(0.3)
				)
				.badgeBackgroundStyle(.secondary)
				BadgeView(
					.legDuration(dur: vm.state.data.durationLabelText),
					color: Color.chewFillTertiary.opacity(0.3)
				)
				.badgeBackgroundStyle(.secondary)
			}
			
			LegsView(journey : vm.state.data,showProgressBar: true)
			BadgeView(
				.updatedAtTime(
					referenceTime: vm.state.data.updatedAt
				),
				color: Color.chewFillTertiary
			)
			.badgeBackgroundStyle(.secondary)
		}
		.onAppear {
			vm.send(event: .didRequestReloadIfNeeded)
		}
	}
}
