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
			let data = vm.state.data.viewData
			HStack {
				NavigationLink(destination: {
					JourneyDetailsView(journeyDetailsViewModel: vm)
				}, label: {
					BadgeView(
						.departureArrivalStops(departure: data.origin, arrival: data.destination),
						.big
					)
				})
			}
			HStack(spacing: 2) {
				BadgeView(
					.date(dateString: data.time.stringDateValue.departure.actualOrPlannedIfActualIsNil() ?? ""),
					.medium
				)
				.badgeBackgroundStyle(.secondary)
				HStack(spacing: 2) {
					TimeLabelView(
						size: .medium,
						arragement: .right,
						time: data.time.stringTimeValue.departure,
						delayStatus: data.time.departureStatus
					)
					Text("-")
					TimeLabelView(
						size: .medium,
						arragement: .right,
						time: data.time.stringTimeValue.arrival,
						delayStatus: data.time.arrivalStatus
					)
				}
				.padding(2)
				.badgeBackgroundStyle(.secondary)
				BadgeView(.legDuration(dur: data.durationLabelText))
					.badgeBackgroundStyle(.secondary)
			}

			LegsView(journey : data,progressBar: true)
			HStack(spacing: 2) {
				Spacer()
				BadgeView(
					.updatedAtTime(
						referenceTime: data.updatedAt,
						isLoading: isLoading(status: vm.state.status)
					),
					color: Color.clear
				)
//				.badgeBackgroundStyle(.secondary)
				if !data.isReachable || !data.legs.allSatisfy({$0.isReachable == true}) {
					BadgeView(.connectionNotReachable)
						.badgeBackgroundStyle(.red)
				}
			}
		}
	}
}

extension JourneyFollowCellView {
	func isLoading(status : JourneyDetailsViewModel.Status) -> Bool {
		if case .loading = status {
			return true
		}
		return false
	}
}

struct FollowCellPreviews: PreviewProvider {
	static var previews: some View {
		let mock = Mock.journeys.journeyNeussWolfsburg.decodedData?.journey
		if let mock = mock,
		   let viewData = mock.journeyViewData(
			   depStop:  .init(),
			   arrStop:  .init(),
			   realtimeDataUpdatedAt: Date.now.timeIntervalSince1970 - 10000
		   ){
			JourneyFollowCellView(journeyDetailsViewModel: .init(
				followId: 0,
				data: viewData,
				depStop: .init(),
				arrStop: .init(),
				chewVM: .init()
			))
			.environmentObject(ChewViewModel())
			.padding()
			.background(Color.gray.opacity(0.1))
		} else {
			Text("error")
		}
	}
}