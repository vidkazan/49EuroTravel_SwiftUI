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
	@State var transferTime = Settings.TransferDurationCases.zero
	@State var transferCount = Settings.TransferCountCases.unlimited
	@State var transportModeSegment = Settings.TransportMode.all
	let allTypes : [LineType] = LineType.allCases
	@State var selectedTypes = Set<LineType>()
	@State var showWithTransfers : Int
	@State var alternativeSearchPage : Bool
//	@State var showSunEvents : Bool
	let closeSheet : ()->Void
	let oldSettings : Settings
	init(settings : Settings,closeSheet : @escaping ()->Void) {
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
		self.alternativeSearchPage = settings.debugSettings.alternativeSearchPage
		self.transferCount = settings.transferCount
//		self.showSunEvents = true
	}
	
	var body: some View {
		NavigationView {
			Form {
				transportTypes
				if transportModeSegment == .custom {
					segments
				}
				connections
				if showWithTransfers == 1 {
					transferSegment
				}
//				debug
			}
			.onAppear {
				loadSettings(state: chewViewModel.state)
			}
			.navigationTitle("Settings")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading, content: {
					Button(action: {
						closeSheet()
					}, label: {
						Text("Cancel")
							.foregroundColor(.chewGray30)
					})
				})	
				ToolbarItem(placement: .navigationBarTrailing, content: {
					Button(action: {
						saveSettings()
						closeSheet()
					}, label: {
						Text("Save")
						.chewTextSize(.big)
						.frame(maxWidth: .infinity,minHeight: 35,maxHeight: 43)
					})
				}
			)}
		}
	}
//	struct DTicketLabel: View {
//		var body: some View {
//			HStack {
//				DTicketLogo(fontSize: 20)
//					.padding(5)
//					.background(Color.gray)
//					.cornerRadius(8)
//				Text("Deutschland ticket")
//			}
//		}
//	}
}

struct SettingsPreview: PreviewProvider {
	static var previews: some View {
		SettingsView(settings: .init(),closeSheet: {})
			.environmentObject(ChewViewModel(referenceDate: .now))
	}
}

extension SettingsView {
	func loadSettings(state : ChewViewModel.State) {
		let settings = state.settings
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
