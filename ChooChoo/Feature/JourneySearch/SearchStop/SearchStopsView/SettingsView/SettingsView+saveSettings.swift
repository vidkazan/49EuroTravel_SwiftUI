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
		let transfer : Settings.TransferTime =  {
			switch self.showWithTransfers {
			case 0:
				return Settings.TransferTime.direct
			default:
				return Settings.TransferTime.time(
					minutes: self.transferTime
				)
			}
		}()
		let res = Settings(
			onboarding: false,
			customTransferModes: selectedTypes,
			transportMode: transportModeSegment,
			transferTime: transfer,
			transferCount: transferCount,
			accessiblity: .partial,
			walkingSpeed: .fast,
			language: .english,
			debugSettings: Settings.ChewDebugSettings(prettyJSON: false,alternativeSearchPage: alternativeSearchPage),
			startWithWalking: true,
			withBicycle: false
		)
		if res != oldSettings {
			chewViewModel.send(event: .didUpdateSettings(res))
			Model.shared.coreDataStore.updateSettings(
				newSettings: res
			)
		}
	}
}
