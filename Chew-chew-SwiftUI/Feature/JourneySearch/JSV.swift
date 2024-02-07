//
//  JourneySearchView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 06.02.24.
//

import Foundation
import SwiftUI


struct JourneySearchView : View {
	@EnvironmentObject var chewViewModel : ChewViewModel
	var body: some View {
		VStack(spacing: 5) {
			SearchStopsView()
			TimeAndSettingsView()
			BottomView()
		}
		.padding(.horizontal,10)
		.background(Color.chewFillPrimary)
		.navigationTitle("ChewChew")
		.navigationBarTitleDisplayMode(.inline)
	}
}
