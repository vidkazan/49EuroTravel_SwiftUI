//
//  JourneyListHeader.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 21.01.24.
//

import Foundation
import SwiftUI

struct JourneyListHeaderView: View {
	@EnvironmentObject var chewVM : ChewViewModel
	@ObservedObject var journeyViewModel : JourneyListViewModel
	var body: some View {
		HStack {
			Button(action: {
				journeyViewModel.send(event: .onReloadJourneyList)
			}, label: {
				Label("Reload", systemImage: "arrow.clockwise")
					.padding(5)
					.frame(maxHeight: 35)
					.chewTextSize(.big)
					.tint(.chewFillTertiary)
					.badgeBackgroundStyle(.secondary)
			})
			Spacer()
			Button(action: {
				chewVM.send(event: .didTapCloseJourneyList)
			}, label: {
				Label("Close", systemImage: "xmark.circle")
					.padding(5)
					.frame(maxHeight: 35)
					.chewTextSize(.big)
					.tint(.chewFillTertiary)
					.badgeBackgroundStyle(.secondary)
			})
		}
	}
}
