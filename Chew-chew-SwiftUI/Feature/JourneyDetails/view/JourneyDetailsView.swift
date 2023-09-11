//
//  JourneyDetails.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.09.23.
//

import SwiftUI

struct JourneyDetailsView: View {
	@EnvironmentObject var chewVM : ChewViewModel
	var body: some View {
		VStack {
			Text("Details")
		}
		.background(.ultraThinMaterial)
		.cornerRadius(10)
		.padding(5)
		.transition(.move(edge: .bottom))
		.animation(.spring(), value: chewVM.state.status)
	}
}

