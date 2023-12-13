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
	let journey : JourneyViewData?
	let isPlaceholder : Bool
	
	init(journey: JourneyViewData, isPlaceholder : Bool = false) {
		self.journey = journey
		self.isPlaceholder = isPlaceholder
	}
	var body: some View {
		VStack {
			JourneyHeaderView(journey: journey)
			LegsView(journey : journey)
				.padding(EdgeInsets(top: 0, leading: 7, bottom: 0, trailing: 7))
			HStack(alignment: .center) {
				PlatformView(
					isShowingPlatormWord: false,
					platform: journey?.legs.first?.legStopsViewData.first?.departurePlatform.actual,
					plannedPlatform: journey?.legs.first?.legStopsViewData.first?.departurePlatform.planned)
				Text(journey?.legs.first?.legStopsViewData.first?.name ?? "")
					.chewTextSize(.medium)
					.tint(.primary)
				Spacer()
				BadgesView(badges: journey?.badges ?? [])
			}
			.padding(7)
		}
		.background(Color.chewFillAccent)
		.overlay {
			if journey?.isReachable == false {
				Color.primary.opacity(0.4)
			}
		}
		.redacted(reason: isPlaceholder ? .placeholder : [])
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
					.chewTextSize(.medium)
				
			}
		}
	}
}
