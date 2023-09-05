//
//  Chew_chew_SwiftUIApp.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 23.08.23.
//

import SwiftUI

@main
struct Chew_chew_SwiftUIApp: App {
	@StateObject private var viewModelChew = SearchLocationViewModel()
	@StateObject private var viewModel2 = SearchJourneyViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
				.environmentObject(viewModelChew)
				.environmentObject(viewModel2)
        }
    }
}
	
