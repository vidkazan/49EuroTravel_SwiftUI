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
	@ObservedObject var appSettingsVM : AppSettingsViewModel = Model.shared.appSettingsVM
	init(journeyDetailsViewModel: JourneyDetailsViewModel) {
		self.vm = journeyDetailsViewModel
	}
	var body: some View {
		let data = vm.state.data.viewData
		VStack(alignment: .leading) {
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
				if let date = data.time.date.departure.actualOrPlannedIfActualIsNil() {
					BadgeView(.date(date: date),.medium)
					.badgeBackgroundStyle(.secondary)
				}
				HStack(spacing: 2) {
					TimeLabelView(
						size: .medium,
						arragement: .right,
						time: data.time.date.departure,
						delayStatus: data.time.departureStatus
					)
					Text(verbatim: "-")
					TimeLabelView(
						size: .medium,
						arragement: .right,
						time: data.time.date.arrival,
						delayStatus: data.time.arrivalStatus
					)
				}
				.padding(2)
				.badgeBackgroundStyle(.secondary)
				BadgeView(.legDuration(data.time))
					.badgeBackgroundStyle(.secondary)
			}
			LegsView(journey : data,mode : appSettingsVM.state.settings.legViewMode)
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
				BadgeView(.generic(msg: "\(data.settings.transportMode)"))
			}
		}
		.contextMenu { menu }
	}
}

extension JourneyFollowCellView {
	var menu : some View {
		Group {
			if !vm.state.data.viewData.options.isEmpty {
				ForEach(vm.state.data.viewData.options, id:\.text) { option in
					Button(action: {
						option.action(vm.state.data.viewData)
					}, label: {
						Label(title: {
							Text(verbatim: option.text)
						}, icon: {
							Image(systemName: option.icon)
						})
					})
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
//
//struct FollowCellPreviews: PreviewProvider {
//	static var previews: some View {
//		let mock = Mock.journeys.journeyNeussWolfsburg.decodedData?.journey
//		if let mock = mock,
//		   let viewData = mock.journeyViewData(
//			   depStop:  .init(),
//			   arrStop:  .init(),
//			   realtimeDataUpdatedAt: Date.now.timeIntervalSince1970 - 10000,
//			   settings: .init()
//		   ){
//			JourneyFollowCellView(journeyDetailsViewModel: .init(
//				followId: 0,
//				data: viewData,
//				depStop: .init(),
//				arrStop: .init(),
//				chewVM: .init()
//			))
//			.environmentObject(ChewViewModel())
//			.padding()
//			.background(Color.gray.opacity(0.1))
//		} else {
//			Text(verbatim: "error")
//		}
//	}
//}
