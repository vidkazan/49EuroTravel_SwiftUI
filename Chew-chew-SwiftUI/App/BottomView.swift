//
//  BottomView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 21.01.24.
//

import Foundation
import SwiftUI

struct BottomView: View {
	@Environment(\.colorScheme) var colorScheme
	@EnvironmentObject var chewViewModel : ChewViewModel
	
	var body: some View {
		if case .journeys(let vm) = chewViewModel.state.status {
			JourneyListView(journeyViewModel: vm)
		} else if case .idle = chewViewModel.state.status  {
			RecentSearchesView(recentSearchesVM: chewViewModel.recentSearchesViewModel)
				.disabled(chewViewModel.recentSearchesViewModel.state.searches.isEmpty)
			Spacer()
		} else {
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
					viewData: data
				)
				BottomView()
					.environmentObject(ChewViewModel(initialState: .init(
						depStop: .textOnly("122"),
						arrStop: .textOnly("123"),
						settings: .init(),
						timeChooserDate: .now,
						status: .journeys(vm)
					)))
			} else {
				Text("error")
			}
		}
	}
}
