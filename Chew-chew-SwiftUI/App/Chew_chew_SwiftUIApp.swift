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
	let persistenceController : PersistenceController
	let context : NSManagedObjectContext
	var chewJourneyViewModel : ChewViewModel
	init() {
		persistenceController = PersistenceController.shared
		context = PersistenceController.shared.container.newBackgroundContext()
		chewJourneyViewModel = ChewViewModel(
			locationDataManager: LocationDataManager(),
			searchStopsViewModel: SearchStopsViewModel(),
			journeyFollowViewModel: JourneyFollowViewModel(journeys: []),
			viewContext: context
		)
	}
	
    var body: some Scene {
        WindowGroup {
			ContentView()
			.environmentObject(chewJourneyViewModel)
			.environment(\.managedObjectContext,context)
        }
    }
}
	
