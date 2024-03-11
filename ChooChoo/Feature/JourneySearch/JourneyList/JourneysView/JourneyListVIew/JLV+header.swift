//
//  JourneyListHeader.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 21.01.24.
//

import Foundation
import SwiftUI
//
//struct JourneyListHeaderView: View {
//	@EnvironmentObject var chewVM : ChewViewModel
//	weak var journeyViewModel : JourneyListViewModel?
//	
//	var body: some View {
//		HStack {
//			Button(action: {
//				journeyViewModel?.send(event: .onReloadJourneyList)
//			}, label: {
//				Label(
//					title: {
//						Text("Reload", comment: "JourneyListHeaderView: ")
//					},
//					icon: {
//						Image(systemName: "arrow.clockwise")
//					}
//				)
//					.padding(5)
//					.frame(maxHeight: 43)
//					.chewTextSize(.big)
//					.tint(.chewFillTertiary)
//					.badgeBackgroundStyle(.secondary)
//			})
//			Spacer()
//			Button(action: {
//				chewVM.send(event: .didTapCloseJourneyList)
//			}, label: {
//				Label(
//					title: {
//						Text("Close", comment: "")
//					},
//					icon: {
//						Image(systemName: "xmark.circle")
//					}
//				)
//					.padding(5)
//					.frame(maxHeight: 43)
//					.chewTextSize(.big)
//					.tint(.chewFillTertiary)
//					.badgeBackgroundStyle(.secondary)
//			})
//		}
//	}
//}
