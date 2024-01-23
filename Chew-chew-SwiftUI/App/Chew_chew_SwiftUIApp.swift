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
			journeyFollowViewModel: JourneyFollowViewModel(coreDataStore: coreDataStore, journeys: []),
			recentSearchesViewModel: RecentSearchesViewModel(coreDataStore: coreDataStore, searches: []),
			coreDataStore: coreDataStore,
			alertViewModel: AlertViewModel()
		)
		
	}
	
	var body: some Scene {
		WindowGroup {
			ContentView()
				.background(Color.chewFillPrimary)
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
		ContentView()
			.environmentObject(ChewViewModel())
	}
}
