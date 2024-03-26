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
	@ObservedObject var appSettingsVM : AppSettingsViewModel = Model.shared.appSettingsVM
	@State var transferTime = JourneySettings.TransferDurationCases.zero
	@State var transferCount = JourneySettings.TransferCountCases.unlimited
	@State var transportModeSegment = JourneySettings.TransportMode.all
	@State var selectedTypes = Set<LineType>()
	@State var showWithTransfers : Int

	@State var currentSettings = JourneySettings()
	let closeSheet : ()->Void
	let oldSettings : JourneySettings
	
	init(settings : JourneySettings,closeSheet : @escaping ()->Void) {
		self.oldSettings = settings
		self.currentSettings = settings
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
		self.transferCount = settings.transferCount
	}
	
	var body: some View {
			Form {
				if appSettingsVM.state.settings.showTip(
					tip: .journeySettingsFilterDisclaimer
				) {
					filterDisclaimer()
				}
				transportTypes
				if transportModeSegment == .custom {
					segments
				}
				connections
				if showWithTransfers == 1 {
					transferSegment
				}
				reset()
			}
			.animation(.easeInOut, value: appSettingsVM.state.settings)
			.onAppear {
				self.currentSettings = oldSettings
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
	let mock = Mock.journeys.journeyNeussWolfsburg.decodedData?.journey.journeyViewData(depStop: nil, arrStop: nil, realtimeDataUpdatedAt: 0,settings: .init())
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

extension SettingsView {
	@ViewBuilder func filterDisclaimer() -> some View {
		if !oldSettings.isDefault() {
			Section {
				AppSettings.ChooTip.journeySettingsFilterDisclaimer.tipLabel
			}
		}
	}
	
	@ViewBuilder func reset() -> some View {
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
}
