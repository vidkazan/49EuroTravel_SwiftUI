//
//  TimeAndSettingsView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 21.01.24.
//

import Foundation
import SwiftUI



struct TimeAndSettingsView: View {
	@Environment(\.colorScheme) var colorScheme
	@EnvironmentObject var chewViewModel : ChewViewModel
	
	var body: some View {
		VStack(spacing: 0) {
			HStack {
				TimeChoosingView(searchStopsVM: chewViewModel.searchStopsViewModel)
				Button(action: {
					chewViewModel.send(event: .didTapSettings)
				}, label: {
					Image(systemName: "gearshape")
						.tint(.primary)
						.frame(maxWidth: 43,maxHeight: 43)
						.background(Color.chewFillAccent)
						.cornerRadius(8)
						.overlay(alignment: .topTrailing) {
							Circle()
								.fill(Color.chewFillRedPrimary)
								.frame(width: 10,height: 10)
								.padding(5)
						}
				})
			}
		}
	}
	
	struct TimeAndSettingsPreview : PreviewProvider {
		static var previews: some View {
			TimeAndSettingsView()
				.padding(10)
				.environmentObject(ChewViewModel())
				.background(Color.chewFillPrimary)
		}
	}
}
