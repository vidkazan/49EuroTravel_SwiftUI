//
//  JourneyFollowView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 13.10.23.
//

import Foundation
import SwiftUI
// TODO: feature: make LegView zoomable, scrollable / show progress on it

struct JourneyFollowView : View {
	
	@Environment(\.managedObjectContext) var viewContext
	@EnvironmentObject var chewVM : ChewViewModel
	@ObservedObject var viewModel : JourneyFollowViewModel
	var body: some View {
		List(viewModel.state.journeys, id: \.journeyRef, rowContent: { journey in
			NavigationLink(destination: {
				JourneyDetailsView(
					token: journey.journeyRef,
					data: journey.journeyViewData,
					depStop: nil,
					arrStop: nil,
					followList: viewModel.state.journeys.map { elem in elem.journeyRef }
				)
			}, label: {
				VStack {
					JourneyHeaderView(journey: journey.journeyViewData)
					LegsView(journey : journey.journeyViewData)
						.padding(EdgeInsets(top: 0, leading: 7, bottom: 0, trailing: 7))
					HStack(alignment: .center) {
						Spacer()
						#warning("place timer to this view")
						BadgeView(badge: .updatedAtTime(referenceTime: journey.journeyViewData.updatedAt))
					}
					.padding(.top,7)
				}
//				.overlay {
//					if journey?.isReachable == false {
//						Color.primary.opacity(0.4)
//					}
//				}
//				.redacted(reason: isPlaceholder ? .placeholder : [])
				.swipeActions(edge: .leading) {
					Button {
						viewModel.send(event: .didTapUpdate)
					} label: {
						Label("Reload", systemImage: "arrow.clockwise")
					}
					.tint(.green)
				}
				.swipeActions(edge: .trailing) {
					Button {
						viewModel.send(event: .didTapEdit(action: .deleting, journeyRef: journey.journeyRef,viewData: journey.journeyViewData))
						ChewJourney.deleteIfFound(deleteRef: journey.journeyRef, in: chewVM.chewJourneys, context: viewContext)
					} label: {
						Label("Delete", systemImage: "xmark.bin.circle")
					}
					.tint(.red)
				}
			})
		})
		.transition(.opacity)
		.animation(.spring().speed(2), value: chewVM.state.status)
		.animation(.spring().speed(2), value: chewVM.searchStopsViewModel.state.status)
	}
}


