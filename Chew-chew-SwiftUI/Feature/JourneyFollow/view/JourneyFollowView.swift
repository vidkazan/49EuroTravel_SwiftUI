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
				JourneyCell(journey: journey.journeyViewData)
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
						ChewJourney.delete(deleteRef: journey.journeyRef, in: chewVM.chewJourneys, context: viewContext)
					} label: {
						Label("Delete", systemImage: "xmark.bin.circle")
					}
					.tint(.red)
				}
			})
		.transition(.opacity)
		.animation(.spring().speed(2), value: chewVM.state.status)
		.animation(.spring().speed(2), value: chewVM.searchStopsViewModel.state.status)
	}
}


