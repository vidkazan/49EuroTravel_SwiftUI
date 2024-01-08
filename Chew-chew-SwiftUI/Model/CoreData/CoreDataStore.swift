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
#warning("contexts are not synced")
final class CoreDataStore : ObservableObject {
	private var asyncContext: NSManagedObjectContext = PersistenceController.shared.container.newBackgroundContext()
	private let viewContext: NSManagedObjectContext =
		PersistenceController.shared.container.viewContext
	
	private var user : ChewUser? = nil
	private var chewJourneys : [ChewJourney]? = nil

	init() {
		self.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
		Task.detached {
			self.asyncContext = PersistenceController.shared.container.newBackgroundContext()
			self.asyncContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
		}
	}
}


// MARK: remove
extension CoreDataStore {
	func deleteJourneyIfFound(journeyRef : String){
		if let objects = self.fetchJourneys() {
			asyncContext.perform {
				if let res = objects.first(where: { obj in
					obj.journeyRef == journeyRef
				}) {
					self.asyncContext.delete(res)
				}
				self.saveAsyncContext()
			}
		}
	}
}







// MARK: add
extension CoreDataStore {
	func addRecentLocation(stop : Stop){
		guard let user = self.user else { return }
		asyncContext.perform {
			print("> ⚡️ create locations thread ",Thread.current)
			let _ = Location(context: self.asyncContext, stop: stop, user: user)
			self.saveAsyncContext()
		}
	}
	func addOrUpdateJourney(viewData : JourneyViewData,depStop : Stop?, arrStop : Stop?){
		guard let chewJourneys = self.chewJourneys else { return }
		guard let ref = viewData.refreshToken,
		let user = self.user else {
			print("📕 > add Journeys : error : ref / user/ journeys")
			return
		}
		print("> ⚡️ add or update Journey thread start",Thread.current)
		ChewJourney.createWith(
			viewData: viewData,
			user: user,
			depStop: depStop,
			arrStop: arrStop,
			ref: ref,
			using: self.asyncContext,
			in: chewJourneys
		)
	}
}



// MARK: update
extension CoreDataStore {
	func updateUser(date : Date){
		guard let user = self.user else { return }
		asyncContext.perform {
			print("> ⚡️ update User thread ",Thread.current)
			user.timestamp = date
			self.saveAsyncContext()
		}
	}
	
	func updateSettings(newSettings : ChewSettings){
		asyncContext.perform {
			print("> ⚡️ update Settings thread ",Thread.current)
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
		print("> ⚡️ save context thread ",Thread.current)
		do {
			try asyncContext.save()
			print("📗 > saved asyncContext")
		} catch {
			let nserror = error as NSError
			print("📕 > save asyncContext: ", nserror.localizedDescription, nserror.userInfo)
		}
	}
}




// MARK: Fetch
extension CoreDataStore {
	func fetchUser() -> ChewUser? {
		let user = self.fetchOrCreate(entity: .user, ChewUser.self)?.first
		self.user = user
		self.chewJourneys = user?.chewJourneys
		return user
	}
	
	func fetchLocations() -> [Stop]? {
		if let res = fetch(Location.self)  {
			let stops = res.map {
				$0.stop()
			}
			return stops
		}
		return nil
	}
	
	func fetchJourneys() -> [ChewJourney]? {
		fetch(ChewJourney.self)
	}
	
	private func fetchOrCreate<T : NSManagedObject>(
		entity : CoreDataStore.Entities,
		_ t : T.Type
	) -> [T]? {

		if let res = fetch(t) {
			return res
		}
		
		asyncContext.perform {
			self.user = ChewUser.createWith(date: .now, using: self.asyncContext)
		}
		return fetch(t)
	}
	
	private func fetch<T : NSManagedObject>(_ t : T.Type) -> [T]? {
		var object : [T]? = nil
		
		asyncContext.performAndWait {
			print("> ⚡️ fetch \(T.self) thread ",Thread.current)
			do {
				guard let fetchRequest = T.fetchRequest() as? NSFetchRequest<T> else {
					print("📕 > basicFetchRequest \(T.self): generate fetch request error")
					return
				}
				let res = try self.asyncContext.fetch(fetchRequest)
				if !res.isEmpty {
					print("📗 > basicFetchRequest \(T.self)")
					object = res
					return
				}
				print("📙 > basicFetchRequest \(T.self): result is empty")
				return
			} catch {
				print("📕 > basicFetchRequest \(T.self): error")
				return
			}
		}
		return object
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
