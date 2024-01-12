//
//  CoreDataStore.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 07.01.24.
//

import Foundation
import CoreData
import CoreLocation


// https://www.reddit.com/r/SwiftUI/comments/tjeb2n/how_to_make_newbackgroundcontext_saveadd_data/
final class CoreDataStore : ObservableObject {
	var asyncContext: NSManagedObjectContext!
	var user : ChewUser? = nil

	init() {
//		self.asyncContext = PersistenceController.shared.container.viewContext
			self.asyncContext = PersistenceController.shared.container.newBackgroundContext()
			self.asyncContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
		}
}


// MARK: remove
extension CoreDataStore {
	func deleteJourneyIfFound(journeyRef : String) -> Bool {
		var result = false
		if let objects = self.fetchJourneys() {
			 asyncContext.performAndWait {
				if let res = objects.first(where: { obj in
					obj.journeyRef == journeyRef
				}) {
//					print("> ⚡️ delete journeys thread ",Thread.current)
					self.asyncContext.delete(res)
					self.saveAsyncContext()
					result = true
				}
			}
		}
		return result
	}
}







// MARK: add
extension CoreDataStore {
	func addRecentLocation(stop : Stop){
		guard let user = self.user else { return }
		 asyncContext.performAndWait {
//			print("> ⚡️ create locations thread ",Thread.current)
			let _ = Location(context: self.asyncContext, stop: stop, user: user)
			self.saveAsyncContext()
		}
	}
	
	func addJourney(viewData : JourneyViewData,depStop : Stop, arrStop : Stop) -> Bool {
		var res = false
		guard let ref = viewData.refreshToken,
		let user = self.user else {
			print("📕 > add Journeys : error : ref / user/ journeys")
			return false
		}
		 asyncContext.performAndWait {
			let _ = ChewJourney(
				viewData: viewData, 
				user: user,
				depStop: depStop,
				arrStop: arrStop,
				ref: ref,
				using: self.asyncContext
			)
			self.cleanupJourneys()
			self.saveAsyncContext()
			res = true
		}
		return res
	}
}

// MARK: update
extension CoreDataStore {
	func updateJourney(viewData : JourneyViewData,depStop : Stop, arrStop : Stop) -> Bool {
		guard let ref = viewData.refreshToken else {
			print("📕 > update Journeys : error : ref")
			return false
		}
		if deleteJourneyIfFound(journeyRef: ref) {
			return addJourney(viewData: viewData, depStop: depStop, arrStop: arrStop)
		}
		return false
	}
	func updateSettings(newSettings : ChewSettings){
		 asyncContext.performAndWait {
//			print("> ⚡️ update Settings thread ",Thread.current)
			guard let user = self.user else {
				print("📕 > update Settings : error : user entity is null")
				return
			}
			guard let settings = user.settings else {
				print("📕 > update Settings : error : settings entity is null")
				return
			}
			
			switch newSettings.transferTime {
			case .direct:
				settings.isWithTransfers = false
				settings.transferTime = 0
			case .time(minutes: let minutes):
				settings.isWithTransfers = true
				settings.transferTime = Int16(minutes)
			}
			
			settings.transportModeSegment = Int16(newSettings.transportMode.rawValue)
			
			
			let modes = newSettings.customTransferModes
			let item = settings.transportModes
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
			item.settings = settings
			
			self.saveAsyncContext()
		}
	}
	
	func saveAsyncContext(){
			do {
				try asyncContext.save()
				print("📗 > saved asyncContext")
			} catch {
				let nserror = error as NSError
				print("📕 > save asyncContext: ", nserror.localizedDescription, nserror.userInfo)
			}
	}
}


// MARK: Entities enum
extension CoreDataStore {
	enum Entities {
		case user
		case locations(stop : Stop, user : ChewUser)
		case journeys
		
		var type : NSManagedObject.Type {
			switch self {
			case .user:
				return ChewUser.self
			case .locations:
				return Location.self
			case .journeys:
				return ChewJourney.self
			}
		}
	}
}

// MARK: cleanup

extension CoreDataStore {
	func cleanupJourneys(){
		if let objects = self.fetch(ChewLeg.self) {
			objects.forEach {
				if $0.journey == nil {
					asyncContext.delete($0)
				}
			}
		}
		if let objects = self.fetch(ChewSunEvent.self) {
			objects.forEach {
				if $0.journey == nil {
					asyncContext.delete($0)
				}
			}
		}
		if let objects = self.fetch(ChewTime.self) {
			objects.forEach {
				if $0.leg == nil,$0.chewJourney == nil,$0.stop == nil {
					asyncContext.delete($0)
				}
			}
		}
	}
}
