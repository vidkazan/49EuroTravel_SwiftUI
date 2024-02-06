//
//  saveSettings.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 23.01.24.
//

import Foundation
import SwiftUI

extension SettingsView {
	func saveSettings(){
		let transportMode = {
			switch self.transportModeSegment {
			case 1:
				return ChewSettings.TransportMode.deutschlandTicket
			case 0:
				return ChewSettings.TransportMode.all
			case 2:
				return ChewSettings.TransportMode.custom
			default:
				return ChewSettings.TransportMode.all
			}
		}()
		let transfer : ChewSettings.TransferTime =  {
			switch self.showWithTransfers {
			case 0:
				return ChewSettings.TransferTime.direct
			case 1:
				return ChewSettings.TransferTime.time(minutes: Int(self.transferTime))
			default:
				return ChewSettings.TransferTime.time(minutes: Int(self.transferTime))
			}
		}()
		
		let res = ChewSettings(
			onboarding: false,
			customTransferModes: selectedTypes,
			transportMode: transportMode,
			transferTime: transfer,
			accessiblity: .partial,
			walkingSpeed: .fast,
			language: .english,
			debugSettings: ChewSettings.ChewDebugSettings(prettyJSON: false,alternativeSearchPage: alternativeSearchPage),
			startWithWalking: true,
			withBicycle: false
		)
		if res != oldSettings {
			chewViewModel.send(event: .didUpdateSettings(res))
			chewViewModel.coreDataStore.updateSettings(
				newSettings: res
			)
		}
	}
}
