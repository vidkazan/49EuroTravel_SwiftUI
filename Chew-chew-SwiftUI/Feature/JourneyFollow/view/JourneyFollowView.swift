//
//  JourneyFollowView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 13.10.23.
//

import Foundation
import SwiftUI

struct JourneyFollowView : View {
	@EnvironmentObject var chewVM : ChewViewModel
	@ObservedObject var viewModel : JourneyFollowViewModel
	init(viewModel: JourneyFollowViewModel) {
		self.viewModel = viewModel
	}
	var body: some View {
		NavigationView {
			List(viewModel.state.journeys, id: \.journeyRef, rowContent: { journey in
				let vm = JourneyDetailsViewModel(
					refreshToken: journey.journeyRef,
					data: journey.journeyViewData,
					depStop: journey.depStop,
					arrStop: journey.arrStop,
					followList: viewModel.state.journeys.map { elem in elem.journeyRef },
					chewVM: chewVM
				)
				NavigationLink(destination: {
					JourneyDetailsView(journeyDetailsViewModel: vm)
				}, label: {
					JourneyFollowCellView(journeyDetailsViewModel: vm)
						.padding(.vertical,5)
				})
			})
		}
		.transition(.opacity)
		.animation(.spring().speed(2), value: viewModel.state.status)
		.navigationBarHidden(true)
	}
}


