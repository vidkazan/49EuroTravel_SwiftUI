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
	
	var body: some View {
		switch chewViewModel.state.status {
		case .journeys(let vm):
			JourneyListView(journeyViewModel: vm)
		case .idle:
			RecentSearchesView(recentSearchesVM: chewViewModel.recentSearchesViewModel)
			Spacer()
		default:
			Spacer()
		}
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
				let vm = JourneyListViewModel(
					viewData: data,
					chewVM: .init()
				)
				BottomView()
					.environmentObject(ChewViewModel(initialState: .init(
						depStop: .textOnly("122"),
						arrStop: .textOnly("123"),
						settings: .init(),
						date: .now,
						status: .journeys(vm)
					)))
			} else {
				Text("error")
			}
		}
	}
}
