//
//  SettingsView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 25.10.23.
//

import Foundation
import SwiftUI

struct SettingsView: View {
	@EnvironmentObject  var chewViewModel : ChewViewModel
	@State var transferTime = JourneySettings.TransferDurationCases.zero
	@State var transferCount = JourneySettings.TransferCountCases.unlimited
	@State var transportModeSegment = JourneySettings.TransportMode.all
	@State var selectedTypes = Set<LineType>()
	@State var showWithTransfers : Int
//	@State var alternativeSearchPage : Bool
//	@State var legViewMode : AppSettings.LegViewMode
	@State var showRedDotWarning : Bool = true
	
	let closeSheet : ()->Void
	let oldSettings : JourneySettings
	
	init(settings : JourneySettings,closeSheet : @escaping ()->Void) {
		self.oldSettings = settings
		self.transportModeSegment = settings.transportMode
		self.selectedTypes = settings.customTransferModes
		self.closeSheet = closeSheet
		
		switch settings.transferTime {
		case .direct:
			self.showWithTransfers = 0
			self.transferTime = .zero
		case .time(minutes: let minutes):
			self.showWithTransfers = 1
			self.transferTime = minutes
		}
//		self.alternativeSearchPage = settings.debugSettings.alternativeSearchPage
		self.transferCount = settings.transferCount
//		self.legViewMode = settings.legViewMode
	}
	
	var body: some View {
			Form {
				if showRedDotWarning == true  {
					if !oldSettings.isDefault() {
						Section {
							HStack(alignment: .top) {
								Label(
									title: {
										Text("Current settings can reduce your search result", comment: "settingsView: warning")
											.foregroundStyle(.secondary)
											.font(.system(.footnote))
									},
									icon: {
										oldSettings.iconBadge.view
									}
								)
								Spacer()
								Button(action: {
									showRedDotWarning = false
								}, label: {
									Image(.xmarkCircle)
										.chewTextSize(.big)
										.tint(.gray)
								})
							}
						}
					}
				}
				transportTypes
				if transportModeSegment == .custom {
					segments
				}
				connections
				if showWithTransfers == 1 {
					transferSegment
				}
				Section {
					Button(role: .destructive, action: {
						Model.shared.alertViewModel.send(
							event: .didRequestShow(.destructive(
								destructiveAction: {
									chewViewModel.send(
										event: .didUpdateSearchData(
											journeySettings: JourneySettings()
										)
									)
									closeSheet()
								},
								description: NSLocalizedString(
									"Reset settings?",
									comment: "alert: description"
								),
								actionDescription: NSLocalizedString(
									"Reset",
									comment: "alert: actionDescription"
								),
								id: UUID()
							))
						)
					}, label: {
						Text("Reset settings",comment: "settingsView: button name")
					})
				}
			}
			.animation(.easeInOut, value: showRedDotWarning)
			.onAppear {
				loadSettings(state: chewViewModel.state)
			}
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing, content: {
					Button(action: {
						saveSettings()
						closeSheet()
					}, label: {
						Text("Save", comment: "settingsView: save button")
						.chewTextSize(.big)
						.frame(maxWidth: .infinity,minHeight: 35,maxHeight: 43)
					})
				}
			)}
	}
}

extension SettingsView {
	func loadSettings(state : ChewViewModel.State) {
		Task {
			let settings = state.data.journeySettings
			self.transportModeSegment = settings.transportMode
			self.selectedTypes = settings.customTransferModes
			switch settings.transferTime {
			case .direct:
				self.showWithTransfers = 0
				self.transferTime = .zero
				self.transferCount = .unlimited
			case .time(minutes: let minutes):
				self.showWithTransfers = 1
				self.transferTime = minutes
				self.transferCount = settings.transferCount
			}
		}
	}
}

struct LegViewSettingsView : View {
	let mode : AppSettings.LegViewMode
	let mock = Mock.journeys.journeyNeussWolfsburg.decodedData?.journey.journeyViewData(depStop: .init(), arrStop: .init(), realtimeDataUpdatedAt: 0,settings: .init())
	var body: some View {
		if let mock = mock {
			LegsView(
				journey: mock,
				mode: mode,
				showLabels: false
			)
		}
	}
}



struct SettingsPreview: PreviewProvider {
	static var previews: some View {
		SettingsView(settings: .init(),closeSheet: {})
			.environmentObject(ChewViewModel(referenceDate: .now))
	}
}
