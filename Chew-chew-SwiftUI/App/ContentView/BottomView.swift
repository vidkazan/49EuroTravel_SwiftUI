//
//  BottomView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 21.01.24.slo
//

import Foundation
import SwiftUI

struct BottomView: View {
	@Environment(\.colorScheme) var colorScheme
	@EnvironmentObject var chewViewModel : ChewViewModel
	@State var state : ChewViewModel.State = .init()
	var body: some View {
		Group {
			switch state.status {
			case let .journeys(stops):
				JourneyListView(
					stops: stops,
					date: state.date,
					settings: state.settings
				)
			case .idle:
				RecentSearchesView(recentSearchesVM: chewViewModel.recentSearchesViewModel)
				Spacer()
			default:
				Spacer()
			}
		}
		.onReceive(chewViewModel.$state, perform: { state = $0 })
	}
}
