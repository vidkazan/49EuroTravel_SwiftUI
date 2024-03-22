//
//  JFCV+Map.swift
//  ChooChoo
//
//  Created by Dmitrii Grigorev on 21.03.24.
//

import Foundation
import SwiftUI
import OrderedCollections

struct JourneyFollowViewMapCell : View {
	@EnvironmentObject var chewVM : ChewViewModel
	@ObservedObject var vm : JourneyDetailsViewModel
	init(journeyDetailsViewModel: JourneyDetailsViewModel) {
		self.vm = journeyDetailsViewModel
	}
	var body: some View {
		let data = vm.state.data.viewData
		ZStack(alignment: .bottomLeading) {
			MapDetailsView(
				mapRect: SheetViewModel.constructMapRegion(
					locFirst: data.legs.first?.legStopsViewData.first?.locationCoordinates ?? .init(),
					locLast: data.legs.last?.legStopsViewData.last?.locationCoordinates ?? .init()
				),
				legs: OrderedSet(data.legs.compactMap({
					SheetViewModel.mapLegData(leg: $0)
				}))
			)
			.frame(minHeight: 300)
			VStack(alignment: .leading,spacing: 2) {
				HStack {
					NavigationLink(destination: {
						JourneyDetailsView(journeyDetailsViewModel: vm)
					}, label: {
						BadgeView(
							.departureArrivalStops(departure: data.origin, arrival: data.destination),
							.big
						)
						.foregroundStyle(.primary)
						.badgeBackgroundStyle(.accent)
					})
				}
				HStack(spacing: 2) {
					if let date = data.time.date.departure.actualOrPlannedIfActualIsNil() {
						BadgeView(.date(date: date),.medium)
							.badgeBackgroundStyle(.accent)
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
					.badgeBackgroundStyle(.accent)
					BadgeView(.legDuration(data.time))
						.badgeBackgroundStyle(.accent)
				}
				
//				LegsView(journey : data,mode : chewVM.state.settings.legViewMode)
			}
			.padding(10)
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
							Image(systemName: "map")
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
}

#Preview {
	JourneyFollowViewMapCell(journeyDetailsViewModel: .init(
		followId: 0,
		data: (Mock.journeys.journeyNeussWolfsburg.decodedData?.journey.journeyViewData(
			depStop: .init(),
			arrStop: .init(),
			realtimeDataUpdatedAt: 0,
			settings: .init()
		))!,
		depStop: .init(),
		arrStop: .init(),
		chewVM: .init()
	))
	.environmentObject(ChewViewModel())
}
