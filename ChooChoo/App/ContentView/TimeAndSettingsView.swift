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
	@State var state : ChewViewModel.State = .init()

	
	var body: some View {
		Group {
			VStack(spacing: 0) {
				HStack {
					TimeChoosingView()
					Button(action: {
						Model.shared.sheetViewModel.send(event: .didRequestShow(.settings))
					}, label: {
						Image(.gearshape)
							.tint(.primary)
							.chewTextSize(.big)
							.frame(maxWidth: 43,maxHeight: 43)
							.background(Color.chewFillAccent)
							.cornerRadius(8)
							.overlay(alignment: .topTrailing) {
								if !chewViewModel.state.settings.isDefault() {
									Circle()
										.fill(Color.chewFillRedPrimary)
										.frame(width: 10,height: 10)
										.padding(5)
								}
							}
					})
				}
			}
		}
		.onReceive(chewViewModel.$state, perform: { newState in
			state = newState
		})
	}
	
	struct TimeAndSettingsPreview : PreviewProvider {
		static var previews: some View {
			TimeAndSettingsView()
				.padding(10)
				.environmentObject(ChewViewModel(referenceDate: .now))
				.background(Color.chewFillPrimary)
		}
	}
}
