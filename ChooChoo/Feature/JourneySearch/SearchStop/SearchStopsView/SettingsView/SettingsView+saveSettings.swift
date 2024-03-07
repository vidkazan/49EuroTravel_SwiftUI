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
			customTransferModes: selectedTypes,
			transportMode: transportModeSegment,
			transferTime: transfer,
			transferCount: transferCount,
			accessiblity: .partial,
			walkingSpeed: .fast,
			language: .english,
			startWithWalking: true,
			withBicycle: false,
			onboarding: false,
			debugSettings: Settings.ChewDebugSettings(
				prettyJSON: false,
				alternativeSearchPage: alternativeSearchPage
			),
			legViewMode: legViewMode
		)
		if res != oldSettings {
			chewViewModel.send(event: .didUpdateSettings(res))
			Model.shared.coreDataStore.updateSettings(
				newSettings: res
			)
		}
	}
}
