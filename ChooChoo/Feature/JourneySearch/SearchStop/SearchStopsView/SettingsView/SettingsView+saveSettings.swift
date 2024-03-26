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
		Task {
			
//			let transfer : JourneySettings.TransferTime =  {
//				switch self.showWithTransfers {
//				case 0:
//					return JourneySettings.TransferTime.direct
//				default:
//					return JourneySettings.TransferTime.time(
//						minutes: self.transferTime
//					)
//				}
//			}()
//			let res = JourneySettings(
//				customTransferModes: selectedTypes,
//				transportMode: transportModeSegment,
//				transferTime: transfer,
//				transferCount: transferCount,
//				accessiblity: .partial,
//				walkingSpeed: .fast,
//				startWithWalking: true,
//				withBicycle: false
//			)
			let newSettings = JourneySettings(settings: currentSettings)
			if newSettings != oldSettings {
				chewViewModel.send(event: .didUpdateSearchData(journeySettings: newSettings))
				Model.shared.coreDataStore.updateJounreySettings(
					newSettings: newSettings
				)
			}
		}
	}
}
