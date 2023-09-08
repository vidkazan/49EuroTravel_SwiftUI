//
//  Chew_chew_SwiftUIApp.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 23.08.23.
//

import SwiftUI

@main
struct Chew_chew_SwiftUIApp: App {
	@StateObject private var searchJourneyViewModel = SearchJourneyViewModel()
	@StateObject private var searchStopViewModel = SearchLocationViewModel(type: .departure)
    var body: some Scene {
        WindowGroup {
            ContentView()
				.environmentObject(searchStopViewModel)
				.environmentObject(searchJourneyViewModel)
        }
    }
}
	
