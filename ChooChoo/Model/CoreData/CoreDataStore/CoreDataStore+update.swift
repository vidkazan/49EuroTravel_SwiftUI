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
	func updateJourney(id: Int64,viewData : JourneyViewData,depStop : Stop, arrStop : Stop) -> Bool {
		if deleteJourneyIfFound(id: id) {
			return addJourney(id: id,viewData: viewData, depStop: depStop, arrStop: arrStop)
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
			guard let settings = user.appSettings else {
				print("📕 > \(#function) : error : settings entity is null")
				return
			}
			settings.legViewMode = newSettings.legViewMode.rawValue
			settings.tipsToShow = try? JSONEncoder()
				.encode(newSettings.tipsToShow)
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
			guard let settings = user.journeySettings else {
				print("📕 > \(#function) : error : settings entity is null")
				return
			}
			
			switch newSettings.transferTime {
			case .direct:
				settings.isWithTransfers = false
				settings.transferTime = 0
			case .time(minutes: let minutes):
				settings.isWithTransfers = true
				settings.transferTime = Int16(minutes.rawValue)
			}
			settings.transportModeSegment = Int16(newSettings.transportMode.rawValue)
			settings.transferCount = newSettings.transferCount.rawValue
			let modes = Self.transportModes(
				modes: newSettings.customTransferModes,
				from: settings.transportModes,
				context: settings.managedObjectContext ?? asyncContext
			)
			
			modes.chooSettings = settings
			
			self.saveAsyncContext()
		}
	}
	
	static func transportModes(
		modes : Set<LineType>,
		from obj : CDTransportModes? = nil,
		context : NSManagedObjectContext
	) -> CDTransportModes {
		let item : CDTransportModes = {
			if let obj = obj {
				return obj
			}
			return CDTransportModes(entity: CDTransportModes.entity(), insertInto: context)
		}()
		item.bus = modes.contains(.bus)
		item.ferry = modes.contains(.ferry)
		item.national = modes.contains(.national)
		item.nationalExpress = modes.contains(.nationalExpress)
		item.regional = modes.contains(.regional)
		item.regionalExpress = modes.contains(.regionalExpress)
		item.suburban = modes.contains(.suburban)
		item.subway = modes.contains(.subway)
		item.taxi = modes.contains(.taxi)
		item.tram = modes.contains(.tram)
		
		return item
	}
}
