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

			LegsView(journey : data,progressBar: true,mode : chewVM.state.settings.legViewMode)
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
		.contextMenu {
			Button(action: {
				Model.shared.sheetViewModel.send(
					event: .didRequestShow(.mapDetails(.journey(data.legs)))
				)
			}, label: {
				Label(
					title: {
						Text("Show on map", comment: "JourneyFollowCellView: menu item")
					},
					icon: {
						Image(systemName: "map.circle")
					}
				)
			})
			Button(action: {
				Model.shared.sheetViewModel.send(
					event: .didRequestShow(.journeyDebug(legs: data.legs.compactMap {$0.legDTO}))
				)
			}, label: {
				Label(
					title: {
						Text("Journey debug", comment: "JourneyFollowCellView: menu item")
					},
					icon: {
						Image(systemName: "ant")
					}
				)
			})
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
			Text(verbatim: "error")
		}
	}
}
