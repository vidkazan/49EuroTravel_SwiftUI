//
//  Settings.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 25.10.23.
//

import Foundation
import SwiftUI

struct AppSettings : Equatable {
	let debugSettings : ChewDebugSettings
	let legViewMode : LegViewMode
	let tips : Set<ChooTipType>
	init(debugSettings : ChewDebugSettings = ChewDebugSettings(
		prettyJSON: false, alternativeSearchPage: false),
		legViewMode : LegViewMode = .sunEvents,
		tips : Set<ChooTipType> = Set(ChooTipType.allCases)
	) {
		self.legViewMode = .sunEvents
		self.tips = tips
		self.debugSettings = debugSettings
	}
	
	init(oldSettings : Self,
		debugSettings : ChewDebugSettings? = nil,
		legViewMode : LegViewMode? = nil,
		tips : Set<ChooTipType>? = nil
	) {
		self.legViewMode = legViewMode ?? oldSettings.legViewMode
		self.tips = tips ?? oldSettings.tips
		self.debugSettings = debugSettings ?? oldSettings.debugSettings
	}
}

extension AppSettings {
	struct ChewDebugSettings: Equatable, Hashable {
		let prettyJSON : Bool
		let alternativeSearchPage : Bool
	}
	
	enum LegViewMode : Int16, Equatable,CaseIterable {
		case sunEvents
		case colorfulLegs
		case all
		
		var showSunEvents : Bool {
			self != .colorfulLegs
		}
		var showColorfulLegs : Bool {
			self != .sunEvents
		}
	}
}

extension AppSettings {
	enum ChooTipType : String ,Equatable, Hashable, CaseIterable {
		case followJourney
		case sunEventsTip
	}
	enum ChooTip : Equatable, Hashable {
		static func == (lhs: ChooTip, rhs: ChooTip) -> Bool {
			lhs.description == rhs.description
		}
		func hash(into hasher: inout Hasher) {
			hasher.combine(description)
		}
		case followJourney
		case sunEvents(onClose: () -> (), journey: JourneyViewData?)
		
		var description  : String {
			switch self {
			case .followJourney:
				return "followJourney"
			case .sunEvents:
				return "sunEvents"
			}
		}
		
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
		
		@ViewBuilder var tipLabel : some View {
			switch self {
			case .followJourney:
				EmptyView()
			case let .sunEvents(close, journey):
				Views.SunEventsTipView(onClose: close, journey: journey)
			}
		}
	}
}

extension AppSettings.ChooTip {
	private struct Views {
		struct SunEventsTipView: View {
			let onClose : () -> ()
			let journey : JourneyViewData?
			var body: some View {
				Button(action: {
					Model.shared.sheetViewModel.send(
						event: .didRequestShow(
							.tip(
								.sunEvents(
									onClose: onClose,
									journey: journey
								)
							)
						)
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
										color: $0.color.opacity(0.4),
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
	}
}

