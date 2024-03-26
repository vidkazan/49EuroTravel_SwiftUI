//
//  Settings.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 25.10.23.
//

import Foundation
import SwiftUI

struct AppSettings : Hashable, Codable {
	let debugSettings : ChewDebugSettings
	let legViewMode : LegViewMode
	let tipsToShow : Set<ChooTipType>
	init(debugSettings : ChewDebugSettings,
		legViewMode : LegViewMode,
		tips : Set<ChooTipType>
	) {
		self.legViewMode = legViewMode
		self.tipsToShow = tips
		self.debugSettings = debugSettings
	}
	
	init(oldSettings : Self,
		debugSettings : ChewDebugSettings? = nil,
		legViewMode : LegViewMode? = nil,
		 tips : Set<ChooTipType>? = nil
	) {
		self.legViewMode = legViewMode ?? oldSettings.legViewMode
		self.tipsToShow = tips ?? oldSettings.tipsToShow
		self.debugSettings = debugSettings ?? oldSettings.debugSettings
	}
	
	init() {
		self.legViewMode = .sunEvents
		self.tipsToShow = Set(ChooTipType.allCases)
		self.debugSettings = ChewDebugSettings(prettyJSON: false, alternativeSearchPage: false)
	}
}

extension AppSettings {
	struct ChewDebugSettings: Equatable, Hashable, Codable {
		let prettyJSON : Bool
		let alternativeSearchPage : Bool
	}
	
	enum LegViewMode : Int16, Hashable,CaseIterable, Codable {
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
	
	enum ChooTipType : String ,Hashable, CaseIterable,Codable {
		case journeySettingsFilterDisclaimer
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
		case journeySettingsFilterDisclaimer
		case sunEvents(onClose: () -> (), journey: JourneyViewData?)
		
		var description  : String {
			switch self {
			case .journeySettingsFilterDisclaimer:
				return "journeySettingsFilterDisclaimer"
			case .followJourney:
				return "followJourney"
			case .sunEvents:
				return "sunEvents"
			}
		}
		
		@ViewBuilder var tipView : some View  {
			Group {
				switch self {
				case .journeySettingsFilterDisclaimer:
					EmptyView()
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
			case .journeySettingsFilterDisclaimer:
				Labels.JourneySettingsFilterDisclaimer()
			case .followJourney:
				EmptyView()
			case let .sunEvents(close, journey):
				Labels.SunEventsTipView(onClose: close, journey: journey)
			}
		}
	}
}

extension AppSettings.ChooTip {
	private struct Labels {
		struct JourneySettingsFilterDisclaimer : View {
			var body: some View {
				HStack(alignment: .top) {
					Label(
						title: {
							Text(
								"Current settings can reduce your search result",
								comment: "settingsView: warning"
							)
								.foregroundStyle(.secondary)
								.font(.system(.footnote))
						},
						icon: {
							JourneySettings.IconBadge.redDot.view
						}
					)
					Spacer()
					Button(action: {
						Model.shared.appSettingsVM.send(event: .didShowTip(tip: .journeySettingsFilterDisclaimer))
					}, label: {
						Image(.xmarkCircle)
							.chewTextSize(.big)
							.tint(.gray)
					})
				}
			}
		}
		
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

extension AppSettings {
	func showTip(tip : ChooTipType) -> Bool {
		if !tipsToShow.contains(tip) {
			return false
		}
		switch tip {
		case .journeySettingsFilterDisclaimer,.followJourney:
			return true
		case .sunEventsTip:
			if self.legViewMode != .colorfulLegs {
				return true
			}
			return false
		}
	}
}
