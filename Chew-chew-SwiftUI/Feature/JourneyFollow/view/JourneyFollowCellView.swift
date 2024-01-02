 //
//  JourneyFollowCellView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 16.12.23.
//

import Foundation
import SwiftUI

struct JourneyFollowCellView : View {
	@Environment(\.managedObjectContext) var viewContext
	@EnvironmentObject var chewVM : ChewViewModel
	@ObservedObject var journeyDetailsViewModel : JourneyDetailsViewModel
	var body: some View {
		VStack(alignment: .leading) {
			HStack {
				Text(journeyDetailsViewModel.state.data.legs.first?.legStopsViewData.first?.name ?? "origin")
					.chewTextSize(.big)
				Image(systemName: "arrow.right")
				Text(journeyDetailsViewModel.state.data.legs.last?.legStopsViewData.last?.name ?? "destination")
					.chewTextSize(.big)
				Spacer()
				if case .loading = journeyDetailsViewModel.state.status {
					ProgressView()
				}
			}
			HStack {
				BadgeView(
					badge: .date(dateString: journeyDetailsViewModel.state.data.timeContainer.stringDateValue.departure.actual ?? "date"),
					color: Color.chewFillTertiary.opacity(0.3)
				)
				BadgeView(
					badge: .timeDepartureTimeArrival(
						timeDeparture: journeyDetailsViewModel.state.data.timeContainer.stringTimeValue.departure.actual ?? "time",
						timeArrival: journeyDetailsViewModel.state.data.timeContainer.stringTimeValue.arrival.actual ?? "time"),
					color: Color.chewFillTertiary.opacity(0.3)
				)
				BadgeView(
					badge: .legDuration(dur: journeyDetailsViewModel.state.data.durationLabelText),
					color: Color.chewFillTertiary.opacity(0.3)
				)
			}
			
			LegsView(journey : journeyDetailsViewModel.state.data)
			BadgeView(badge: .updatedAtTime(referenceTime: journeyDetailsViewModel.state.data.updatedAt),color: Color.chewFillTertiary.opacity(0.2))
		}
		.onAppear {
			journeyDetailsViewModel.send(event: .didRequestReloadIfNeeded)
		}
//		.swipeActions(edge: .leading) {
//			Button {
//				journeyDetailsViewModel.send(event: .didTapReloadJourneyList)
//			} label: {
//				Label("Reload", systemImage: "arrow.clockwise")
//			}
//			.tint(.green)
//		}
//		.swipeActions(edge: .trailing) {
//			Button {
//				if let ref = journeyDetailsViewModel.state.data.refreshToken {
//					journeyFollowViewModel.send(event: .didTapEdit(
//						action: .deleting, journeyRef: ref,
//						viewData: journeyDetailsViewModel.state.data
//					))
//					ChewJourney.deleteIfFound(
//						deleteRef: ref,
//						in: chewVM.chewJourneys,
//						context: viewContext
//					)
//				}
//			} label: {
//				Label("Delete", systemImage: "xmark.bin.circle")
//			}
//			.tint(.red)
//		}
	}
}
