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
	@ObservedObject var alertVM : AlertViewModel = Model.shared.alertViewModel
	
	let alert : AlertViewModel.AlertType
	
	var body: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 10)
				.fill(alert.bgColor)
				.frame(height: 35)
				.cornerRadius(10)
			HStack {
				if let infoAction = alert.infoAction {
					Button(
						action: infoAction, label: {
							Label("", systemImage: "info.circle")
								.labelStyle(.iconOnly)
								.foregroundColor(.white.opacity(0.7))
								.chewTextSize(.big)
								.lineLimit(1)
						})
					.padding(.leading,15)
				}
				Spacer()
				if case .none = alert.action {
					EmptyView()
				} else {
					Button(action: {
						switch alert.action {
						case .dismiss:
							alertVM.send(event: .didRequestDismiss(alert))
						case .reload(let action):
							action()
						case .none:
							break
						}
					}, label: {
						Label("", systemImage: alert.action.iconName)
							.labelStyle(.iconOnly)
							.foregroundColor(.white.opacity(0.7))
							.chewTextSize(.big)
							.lineLimit(1)
					})
					.padding(.trailing,15)
				}
			}
			.frame(maxWidth: .infinity,maxHeight: 35)
			BadgeView(alert.badgeType)
				.foregroundColor(.white)
				.chewTextSize(.medium)
				.cornerRadius(10)
				.frame(maxWidth: .infinity,maxHeight: 35)
		}
		.frame(maxWidth: .infinity,maxHeight: 35)
	}
}


struct AlertsView: View {
	@EnvironmentObject var chewJourneyViewModel : ChewViewModel
	@ObservedObject var alertVM : AlertViewModel = Model.shared.alertViewModel
	let timer = Timer.publish(every: 15, on: .main, in: .common).autoconnect()
	var body: some View {
		Group {
			switch alertVM.state.status {
			case .start:
				EmptyView()
			case .showing,.adding,.deleting :
				if !alertVM.state.alerts.isEmpty {
					VStack(spacing: 2) {
						ForEach(alertVM.state.alerts.sorted(by: <), id: \.hashValue, content: { alert in
							AlertView(alertVM: alertVM, alert: alert)
						})
					}
					.padding(.horizontal,10)
				}
			}
		}
		.onReceive(timer, perform: { _ in
			var types = alertVM.state.alerts.filter({ type in
				switch type.action {
				case .none:
					return false
				default:
					return true
				}
			})
			if let last = types.popFirst(), let event = last.action.alertViewModelEvent(alertType: last) {
				alertVM.send(event: event)
			}
		})
	}
}

struct AlertViewPreview : PreviewProvider {
	static var previews: some View {
		AlertsView()
	}
}

