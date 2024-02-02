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
			alertViewModel: AlertViewModel(),
			referenceDate: .now
		)
		
	}
	
	var body: some Scene {
		WindowGroup {
			ContentView()
				.environmentObject(chewJourneyViewModel)
		}
	}
}

struct AppViewPreview : PreviewProvider {
	static var previews: some View {
		ContentView()
			.environmentObject(ChewViewModel())
	}
}
