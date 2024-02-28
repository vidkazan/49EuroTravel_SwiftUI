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
	let arr = [0,5,7,10,15,20,30,45,60,90,120]
	@State var transportModeSegment : Int
	let allTypes : [LineType] = LineType.allCases
	@State var selectedTypes = Set<LineType>()
	@State var transferTime : Int
	@State var showWithTransfers : Int
	@State var alternativeSearchPage : Bool
//	@State var showSunEvents : Bool
	let closeSheet : ()->Void
	let oldSettings : ChewSettings
	init(settings : ChewSettings,closeSheet : @escaping ()->Void) {
		self.oldSettings = settings
		self.transportModeSegment = settings.transportMode.id
		self.selectedTypes = settings.customTransferModes
		self.closeSheet = closeSheet
		
		switch settings.transferTime {
		case .direct:
			self.showWithTransfers = 0
			self.transferTime = 0
		case .time(minutes: let minutes):
			self.showWithTransfers = 1
			self.transferTime = minutes
		}
		self.alternativeSearchPage = settings.debugSettings.alternativeSearchPage
//		self.showSunEvents = true
	}
	
	var body: some View {
		NavigationView {
			Form {
				transportTypes
				if transportModeSegment == 2 {
					segments
				}
				connections
//				debug
			}
			.onChange(of: chewViewModel.state, perform: loadSettings)
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
	struct DTicketLabel: View {
		var body: some View {
			HStack {
				DTicketLogo(fontSize: 20)
					.padding(5)
					.background(Color.gray)
					.cornerRadius(8)
				Text("Deutschland ticket")
			}
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
	func loadSettings(state : ChewViewModel.State) {
		let settings = state.settings
		self.transportModeSegment = settings.transportMode.id
		self.selectedTypes = settings.customTransferModes
		
		switch settings.transferTime {
		case .direct:
			self.showWithTransfers = 0
			self.transferTime = 0
		case .time(minutes: let minutes):
			self.showWithTransfers = 1
			self.transferTime = minutes
		}
	}
}
