 //
//  Chew_chew_SwiftUIApp.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 23.08.23.
//

import SwiftUI
import CoreData

@main
struct Chew_chew_SwiftUIApp: App {
	var chewJourneyViewModel : ChewViewModel
	let coreDataStore : CoreDataStore
	
	init() {
		coreDataStore = CoreDataStore()
		
		chewJourneyViewModel = ChewViewModel(
			locationDataManager: LocationDataManager(),
			searchStopsViewModel: SearchStopsViewModel(),
			journeyFollowViewModel: JourneyFollowViewModel(chewVM: nil, journeys: []),
			coreDataStore: coreDataStore,
			alertViewModel: AlertViewModel()
		)
		
	}
	
	var body: some Scene {
		WindowGroup {
			ContentView()
				.environmentObject(chewJourneyViewModel)
				.transition(.move(edge: .bottom))
				.animation(.spring().speed(2), value: chewJourneyViewModel.state.status)
				.animation(.spring().speed(2), value: chewJourneyViewModel.searchStopsViewModel.state.status)
				.animation(.spring().speed(2), value: chewJourneyViewModel.alertViewModel.state.status)
		}
	}
}

struct AppViewPreview : PreviewProvider {
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
			ContentView()
				.environmentObject(ChewViewModel(
					locationDataManager: .init(),
					searchStopsViewModel: .init(),
					journeyFollowViewModel: .init(journeys: []),
					coreDataStore: .init(),
					alertViewModel: .init(),
					initialState: .init(
						depStop: .textOnly(""),
						arrStop: .textOnly(""),
						settings: .init(),
						timeChooserDate: .now,
						status: .start
					)
				))
		} else {
			Text("error")
		}
	}
}
