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
	var chewViewModel : ChewViewModel
	let coreDataStore : CoreDataStore
	
	init() {
		coreDataStore = CoreDataStore()
		
		chewViewModel = ChewViewModel(
			sheetViewModel: SheetViewModel(),
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
			ContentView(sheetVM: chewViewModel.sheetViewModel)
				.background(Color.chewFillPrimary)
				.environmentObject(chewViewModel)
		}
	}
}

struct AppViewPreview : PreviewProvider {
	static var previews: some View {
		let chewVM = ChewViewModel()
		ContentView(sheetVM: chewVM.sheetViewModel)
			.environmentObject(chewVM)
	}
}
