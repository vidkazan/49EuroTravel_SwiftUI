//
//  JourneyCell.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//

import Foundation
import SwiftUI

struct JourneyCell: View {
	@EnvironmentObject var chewVM : ChewViewModel
	let journey : JourneyViewData
	init(journey: JourneyViewData) {
		self.journey = journey
	}
	
	var body: some View {
		VStack {
			JourneyHeaderView(journey: journey)
			LegsView(journey : journey)
			HStack(alignment: .center) {
				PlatformView(
					isShowingPlatormWord: false,
					platform: journey.legDTO?.first?.departurePlatform,
					plannedPlatform: journey.legDTO?.first?.plannedDeparturePlatform)
				Text(journey.legDTO?.first?.origin?.name != chewVM.topSearchFieldText ? journey.legDTO?.first?.origin?.name ?? "" : "")
					.font(.system(size: 12,weight: .semibold))
					.foregroundColor(.secondary)
				Spacer()
				BadgesView(badges: journey.badges)
			}
			.padding(7)
			
		}
//		.background(.ultraThinMaterial.opacity(0.5))
		.background(.gray.opacity(0.1))
		.overlay {
			if !journey.isReachable {
				Color.black.opacity(0.7)
			}
		}
		.cornerRadius(10)
	}
}

struct PlatformView: View {
	let isShowingPlatormWord : Bool
	let platform : String?
	let plannedPlatform : String?
	var body: some View {
		if let pl = platform {
			HStack(spacing: 2) {
				if isShowingPlatormWord == true {
					Text("platform")
						.foregroundColor(.gray)
					.font(.system(size: 12,weight: .regular))
				}
				Text(pl)
					.padding(3)
					.frame(minWidth: 20)
					.background(Color(red: 0.1255, green: 0.156, blue: 0.4))
					.foregroundColor(pl == plannedPlatform ? .primary : .red)
					.font(.system(size: 12,weight: .semibold))
					
			}
		}
	}
}
