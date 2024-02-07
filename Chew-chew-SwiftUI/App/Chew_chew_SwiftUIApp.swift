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
	var chewViewModel = ChewViewModel(referenceDate: .now)
	
	var body: some Scene {
		WindowGroup {
			ContentView()
				.background(Color.chewFillPrimary)
				.environmentObject(chewViewModel)
		}
	}
}
