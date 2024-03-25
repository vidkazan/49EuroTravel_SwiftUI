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
			let transfer : JourneySettings.TransferTime =  {
				switch self.showWithTransfers {
				case 0:
					return JourneySettings.TransferTime.direct
				default:
					return JourneySettings.TransferTime.time(
						minutes: self.transferTime
					)
				}
			}()
			let res = JourneySettings(
				customTransferModes: selectedTypes,
				transportMode: transportModeSegment,
				transferTime: transfer,
				transferCount: transferCount,
				accessiblity: .partial,
				walkingSpeed: .fast,
				startWithWalking: true,
				withBicycle: false
			)
			if res != oldSettings {
				chewViewModel.send(event: .didUpdateSearchData(journeySettings: res))
				Model.shared.coreDataStore.updateJounreySettings(
					newSettings: res
				)
			}
		}
	}
}
