//
//  AlertView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 17.01.24.
//

import Foundation
import SwiftUI

struct AlertView: View {
	@EnvironmentObject var chewJourneyViewModel : ChewViewModel
	@ObservedObject var alertVM : AlertViewModel
	
	var body: some View {
		switch alertVM.state.status {
		case .hidden,.start:
			EmptyView()
		case .showing,.updating:
			ZStack {
				RoundedRectangle(cornerRadius: 10)
					.fill(Color.chewFillBluePrimary)
					.cornerRadius(10)
					.frame(maxWidth: .infinity,maxHeight: 35)
					.overlay(alignment: .trailing) {
						Button(action: {
							
						}, label: {
							Label("", systemImage: "arrow.clockwise")
								.labelStyle(.iconOnly)
								.foregroundColor(.white)
								.chewTextSize(.big)
								.lineLimit(1)
						})
						.padding(.horizontal,15)
					}
				BadgeView(.offlineMode)
					.foregroundColor(.white)
//					.badgeBackgroundStyle(.blue)
					.chewTextSize(.medium)
					.cornerRadius(10)
			}
			.padding(.horizontal,10)
			.padding(.vertical,5)
//			.background(Color.chewFillPrimary)
		}
	}
}

struct AlertViewPreview : PreviewProvider {
	static var previews: some View {
		AlertView(alertVM: .init(.showing))
	}
}

