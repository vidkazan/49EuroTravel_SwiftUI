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
					settingsBtn()
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

extension TimeAndSettingsView {
	@ViewBuilder func settingsBtn() -> some View {
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
					chewViewModel.state.settings.iconBadge.view
						.padding(5)
				}
		})
	}
}

#Preview {
	HStack {
		Settings.IconBadge.redDot.view
		Settings.IconBadge.regional.view
	}
}
