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
	@EnvironmentObject var chewVM : ChewViewModel
	@ObservedObject var viewModel : JourneyFollowViewModel
	var body: some View {
		VStack {
			ForEach(viewModel.state.journeys, id: \.journeyRef, content: { journey in
				Text(journey.journeyRef)
					.font(.system(size: 7, weight: .medium))
			})
		}
		.transition(.opacity)
		.animation(.spring().speed(2), value: chewVM.state.status)
		.animation(.spring().speed(2), value: chewVM.searchStopsViewModel.state.status)
	}
}


