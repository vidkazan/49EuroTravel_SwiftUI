//
//  Info.swift
//  ChooChoo
//
//  Created by Dmitrii Grigorev on 08.03.24.
//

import Foundation
import SwiftUI

enum ChooTip {
	case followJourney
	case sunEvents(onClose: () -> (), journey: JourneyViewData?)
	
	@ViewBuilder var tipView : some View  {
		Group {
			switch self {
			case .followJourney:
				HowToFollowJourneyView()
			case .sunEvents:
				LegViewSettingsView(mode: .sunEvents)
			}
		}
		.padding(5)
	}
	
	@ViewBuilder var tipLabel : some View  {
		switch self {
		case .followJourney:
			EmptyView()
		case let .sunEvents(close, journey):
			SunEventsTipView(onClose: close, journey: journey)
		}
	}
}

struct SunEventsTipView: View {
	let onClose : () -> ()
	let journey : JourneyViewData?
	var body: some View {
		Button(action: {
			Model.shared.sheetViewModel.send(
				event: .didRequestShow(.tip(tipType: .sunEvents(
					onClose: onClose,
					journey: journey)))
			)
		}, label : {
			HStack {
				Label(
					title: {
						Text("What does this colorful line mean?", comment: "jlv: header info: sunevents")
							.chewTextSize(.medium)
					},
					icon: {
						ChooSFSymbols.infoCircle.view
					}
				)
				.tint(.primary)
				Spacer()
				Button(action: {
					onClose()
				}, label: {
					ChooSFSymbols.xmarkCircle.view
						.chewTextSize(.big)
						.tint(.gray)
				})
				.frame(width: 40, height: 40)
			}
			.padding(5)
			.frame(height: 40)
			.background {
				LinearGradient(
					stops: journey?
						.sunEventsGradientStops
						.map {
							.init(
								color: $0.color.opacity(0.3),
								location: $0.location
							)
						} ?? .init(),
					startPoint: .leading,
					endPoint: .trailing
				)
			}
			.clipShape(.rect(cornerRadius: 8))
		})
	}
}
