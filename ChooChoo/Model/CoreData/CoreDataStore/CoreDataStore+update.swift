//
//  CoreDataStore.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 07.01.24.
//

import Foundation
import CoreData
import CoreLocation
// MARK: update
extension CoreDataStore {
	func updateJourney(id: Int64,viewData : JourneyViewData,stops : DepartureArrivalPairStop) -> Bool {
		if deleteJourneyIfFound(id: id) {
			return addJourney(id: id,viewData: viewData, stops: stops)
		}
		print("📕 > \(#function) : error : delete fault")
		return false
	}
	func updateAppSettings(newSettings : AppSettings){
		asyncContext.performAndWait {
			guard let user = self.user else {
				print("📕 > \(#function) : error : user entity is null")
				return
			}
			guard let settings = try? JSONEncoder().encode(newSettings) else {
				return
			}
			user.appSettings = settings
			self.saveAsyncContext()
		}
	}
	func updateJounreySettings(newSettings : JourneySettings){
		asyncContext.performAndWait {
			//			print("> ⚡️ update Settings thread ",Thread.current)
			guard let user = self.user else {
				print("📕 > \(#function) : error : user entity is null")
				return
			}
			guard let settings = try? JSONEncoder().encode(newSettings) else {
				print("📕 > \(#function) : error : settings encoding failed")
				return
			}
			
			user.journeySettings = settings
			self.saveAsyncContext()
		}
	}
}
