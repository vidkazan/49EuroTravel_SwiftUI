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
	
	struct BottomViewPreview : PreviewProvider {
		static var previews: some View {
			let mock = Mock.journeyList.journeyNeussWolfsburg.decodedData
			if let mock = mock {
				let viewData = constructJourneyListViewData(
					journeysData: mock,
					depStop: .init(),
					arrStop: .init()
				)
				let data = JourneyListViewData(
					journeysViewData: viewData,
					data: mock,
					depStop: .init(),
					arrStop: .init()
				)
				BottomView()
					.environmentObject(ChewViewModel(initialState: .init(
						depStop: .textOnly("122"),
						arrStop: .textOnly("123"),
						settings: .init(),
						date: .now,
						status: .journeys(.init(departure: .init(), arrival: .init()))
					)))
			} else {
				Text("error")
			}
		}
	}
}
