//
//  ContentView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 23.08.23.
//

import SwiftUI
#warning("TODO: move all sheets to root sheet")
#warning("TODO: split chewVM reducer")
#warning("TODO: legView: place transport icons")
#warning("TODO: grouped animations with @namespaces https://gist.github.com/michael94ellis/5a46a5c2983da0cc99692b6659876fce")
#warning("TODO: .reducted (placeholder view) with mock data")
#warning("TODO: bug: journey: if arrival stop cancelled, duration is NULL")
#warning("TODO: bug: journey: stop is showing totally cancelled if only exit / entrance is allowed")
#warning("TODO: error and alerts")
#warning("TODO: sheet detents")

struct ContentView: View {
	@Environment(\.colorScheme) var colorScheme
	@EnvironmentObject var chewViewModel : ChewViewModel
		
	var body: some View {
		NavigationView {
			VStack(spacing: 5) {
				AlertsView(alertVM: chewViewModel.alertViewModel)
				FeatureView()
			}
		}
		.onAppear {
			chewViewModel.send(event: .didStartViewAppear)
			UITabBar.appearance().backgroundColor = UIColor(Color.chewFillPrimary)
		}
	}
	
	struct ContentViewPreview : PreviewProvider {
		static var previews: some View {
			let mock = Mock.journeyList.journeyNeussWolfsburg.decodedData
			if let mock = mock {
				let viewData = constructJourneyListViewData(journeysData: mock,depStop: .init(),arrStop: .init())
				let data = JourneyListViewData(journeysViewData: viewData,data: mock,depStop: .init(),arrStop: .init())
				let vm = JourneyListViewModel(viewData: data)
				Group {
					ContentView()
						.environmentObject(ChewViewModel(initialState: .init(
							depStop: .textOnly(""),
							arrStop: .textOnly(""),
							settings: .init(),
							timeChooserDate: .now,
							status: .journeys(vm)
						)))
					ContentView()
						.environmentObject(ChewViewModel())
				}
			} else {
				Text("error")
			}
		}
	}
}
