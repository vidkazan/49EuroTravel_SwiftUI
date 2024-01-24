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
		case .showing(let type),.updating(let type):
			ZStack {
				RoundedRectangle(cornerRadius: 10)
					.fill(type.bgColor)
					.cornerRadius(10)
					.frame(maxWidth: .infinity,maxHeight: 35)
					.overlay(alignment: .trailing) {
						HStack {
							Button(action: {
								UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
							}, label: {
								Label("", systemImage: "info.circle")
									.labelStyle(.iconOnly)
									.foregroundColor(.white)
									.chewTextSize(.big)
									.lineLimit(1)
							})
							.padding(.leading,15)
							Spacer()
							Button(action: {
								switch type.action {
								case .dismiss:
									alertVM.send(event: .didTapDismiss(type))
								case .reload(let action):
									action()
								case .none:
									break
								}
							}, label: {
								if case .none = type.action {
									EmptyView()
								} else {
									Label("", systemImage: type.action.iconName)
										.labelStyle(.iconOnly)
										.foregroundColor(.chewFillAccent)
										.chewTextSize(.big)
										.lineLimit(1)
								}
							})
							.padding(.trailing,15)
						}
					}
				BadgeView(type.badgeType)
					.foregroundColor(.white)
					.chewTextSize(.medium)
					.cornerRadius(10)
			}
			.padding(.horizontal,10)
			.padding(.vertical,5)
		}
	}
}

struct AlertViewPreview : PreviewProvider {
	static var previews: some View {
		VStack{
			AlertView(alertVM: .init(.showing(.offlineMode)))
			AlertView(alertVM: .init(.showing(.userLocation)))
		}
	}
}

