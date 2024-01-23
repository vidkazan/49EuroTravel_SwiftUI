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
	let oldSettings : ChewSettings
	init(settings : ChewSettings) {
		self.oldSettings = settings
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
	
	var body: some View {
		NavigationView {
			Form {
				transportTypes
				if transportModeSegment == 2 {
					segments
				}
				connections
			}
			.onChange(of: chewViewModel.state, perform: loadSettings)
			.onDisappear {
				chewViewModel.send(event: .didDismissBottomSheet)
			}
			.navigationTitle("Settings")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading, content: {
					Button(action: {
						chewViewModel.send(event: .didDismissBottomSheet)
					}, label: {
						Text("Cancel")
							.foregroundColor(.chewGray30)
					})
				})	
				ToolbarItem(placement: .navigationBarTrailing, content: {
					Button(action: {
						saveSettings()
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
		SettingsView(settings: .init())
			.environmentObject(ChewViewModel())
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
