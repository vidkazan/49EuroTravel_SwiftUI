 //
//  JourneyFollowCellView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 16.12.23.
//

import Foundation
import SwiftUI

struct JourneyFollowCellView : View {
	let timer = Timer.publish(every: 70, on: .main, in: .common).autoconnect()
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
					BadgeView(
						.departureArrivalStops(departure: data.origin, arrival: data.destination),
						.big
					)
				})
			}
			HStack(spacing: 2) {
				BadgeView(
					.date(dateString: data.timeContainer.stringDateValue.departure.actualOrPlannedIfActualIsNil() ?? ""),
					.medium
				)
				.badgeBackgroundStyle(.secondary)
				HStack(spacing: 2) {
					TimeLabelView(
						isSmall: true,
						arragement: .right,
						delay: data.timeContainer.departureStatus.value,
						time: data.timeContainer.stringTimeValue.departure,
						isCancelled: !data.isReachable
					)
					Text("-")
					TimeLabelView(
						isSmall: true,
						arragement: .right,
						delay: data.timeContainer.arrivalStatus.value,
						time: data.timeContainer.stringTimeValue.arrival,
						isCancelled: !data.isReachable
					)
				}
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
						isLoading: isLoading
					),
					color: Color.chewFillTertiary
				)
				.badgeBackgroundStyle(.secondary)
				if !data.isReachable || !data.legs.allSatisfy({$0.isReachable == true}) {
					BadgeView(.connectionNotReachable)
						.badgeBackgroundStyle(.red)
				}
			}
		}
		.onReceive(vm.$state, perform: { state in
			switch state.status {
			case .loading,.loadingIfNeeded:
				isLoading = true
			default:
				isLoading = false
			}
			
		})
		.onReceive(timer, perform: { _ in
			vm.send(event: .didRequestReloadIfNeeded(ref: vm.state.data.viewData.refreshToken))
		})
	}
}


struct FollowCellPreviews: PreviewProvider {
	static var previews: some View {
		let mock = Mock.journeys.journeyNeussWolfsburg.decodedData?.journey
		if let mock = mock,
		   let viewData = constructJourneyViewData(
			   journey: mock,
			   depStop:  .init(),
			   arrStop:  .init(),
			   realtimeDataUpdatedAt: Date.now.timeIntervalSince1970 - 10000
		   ){
			JourneyFollowCellView(journeyDetailsViewModel: .init(
				refreshToken: "",
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
