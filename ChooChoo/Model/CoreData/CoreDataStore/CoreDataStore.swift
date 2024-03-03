//
//  CoreDataStore.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 07.01.24.
//

import Foundation
import CoreData
import CoreLocation

final class CoreDataStore : ObservableObject {
	var asyncContext: NSManagedObjectContext!
	var user : ChewUser? = nil

	init() {
			self.asyncContext = PersistenceController.shared.container.newBackgroundContext()
			self.asyncContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
		}
}


func differenceBetweenStrings(_ str1: String, _ str2: String) -> String {
	var difference = ""
	
	// Convert strings to arrays of characters for easier comparison
	let array1 = Array(str1)
	let array2 = Array(str2)
	
	// Find the difference between the two arrays
	for (char1, char2) in zip(array1, array2) {
		if char1 != char2 {
			difference.append(char1)
		}
	}
	
	return difference
}

// MARK: remove
extension CoreDataStore {
	func deleteJourneyIfFound(id : Int64) -> Bool {
		var result = false
		if let objects = self.fetchJourneys() {
			 asyncContext.performAndWait {
				if let res = objects.first(where: { obj in
					return obj.id == id
				}) {
//					print("> ⚡️ delete journeys thread ",Thread.current)
					self.asyncContext.delete(res)
					self.saveAsyncContext()
					result = true
				} else {
					print("📕 > delete JourneysIfFound : error : not found")
				}
			}
		} else {
			print("📕 > delete JourneysIfFound : error : fetch fault")
		}
		return result
	}
	func deleteRecentLocationIfFound(name : String) -> Bool {
		var result = false
		
		if let objects = self.fetch(Location.self) {
			 asyncContext.performAndWait {
				 let res = objects.filter({$0.chewJourneyArr == nil && $0.chewJourneyDep == nil && $0.chewRecentSearchDepStop == nil && $0.chewRecentSearchArrStop == nil})
				if let res = res.first(where: { obj in
					return obj.name == name
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
	func deleteRecentSearchIfFound(id : String) -> Bool {
		var result = false
		if let objects = self.fetch(ChewRecentSearch.self) {
			 asyncContext.performAndWait {
				if let res = objects.first(where: { obj in
					return obj.id == id
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
			 if let prod = stop.stopDTO?.products {
				 let _ = Location(
					context: self.asyncContext,
					stop: stop,
					parent: .recentLocation(user),
					products: prod
				 )
				 self.saveAsyncContext()
			 }
		}
	}
	
	func addJourney(id : Int64,viewData : JourneyViewData,depStop : Stop, arrStop : Stop) -> Bool {
		var res = false
		guard let user = self.user else {
			print("📕 > \(#function) : error : ref / user/ journeys")
			return false
		}
		asyncContext.performAndWait {
			let _ = ChewJourney(
				viewData: viewData,
				user: user,
				depStop: depStop,
				arrStop: arrStop,
				id: id,
				using: self.asyncContext
			)
			self.saveAsyncContext()
			res = true
		}
		return res
	}
	
	func addRecentSearch(search : RecentSearchesViewModel.RecentSearch) -> Bool {
		var res = false
		guard let user = self.user else {
			print("📕 > \(#function) : error : user")
			return false
		}
		 asyncContext.performAndWait {
			let _ = ChewRecentSearch(
				user: user,
				search: search,
				using: self.asyncContext
			)
			self.saveAsyncContext()
			res = true
		}
		return res
	}
}

// MARK: update
extension CoreDataStore {
	func disableOnboarding(){
		asyncContext.performAndWait {
			guard let user = self.user else {
				print("📕 > update Settings : error : user entity is null")
				return
			}
			guard let settings = user.settings else {
				print("📕 > update Settings : error : settings entity is null")
				return
			}
			settings.onboarding = false
			self.saveAsyncContext()
		}
	}
	func updateJourney(id: Int64,viewData : JourneyViewData,depStop : Stop, arrStop : Stop) -> Bool {
		if deleteJourneyIfFound(id: id) {
			return addJourney(id: id,viewData: viewData, depStop: depStop, arrStop: arrStop)
		}
		print("📕 > update Journeys : error : delete fault")
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
				settings.transferTime = Int16(minutes.rawValue)
			}
			
			settings.transportModeSegment = Int16(newSettings.transportMode.rawValue)
			 settings.transferCount = newSettings.transferCount.rawValue
			let modes = Self.transportModes(
				modes: newSettings.customTransferModes,
				from: settings.transportModes,
				context: settings.managedObjectContext ?? asyncContext
			)
			 
			modes.settings = settings
			
			self.saveAsyncContext()
		}
	}
	
	static func transportModes(
		modes : Set<LineType>,
		from obj : TransportModes? = nil,
		context : NSManagedObjectContext
	) -> TransportModes {
		let item : TransportModes = {
			if let obj = obj {
				return obj
			}
			return TransportModes(entity: TransportModes.entity(), insertInto: context)
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
		case recentSearches
		
		var type : NSManagedObject.Type {
			switch self {
			case .recentSearches:
				return ChewRecentSearch.self
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



enum CoreDataError : ChewError {
	static func == (lhs: CoreDataError, rhs: CoreDataError) -> Bool {
		return lhs.description == rhs.description
	}
	
	func hash(into hasher: inout Hasher) {
		switch self {
		case .failedToUpdateDatabase:
			break
		case .failedToAdd:
			break
		case .failedToDelete:
			break
		}
	}
	case failedToUpdateDatabase(type : NSManagedObject.Type)
	case failedToAdd(type : NSManagedObject.Type)
	case failedToDelete(type : NSManagedObject.Type)
	
	
	var description : String  {
		switch self {
		case .failedToUpdateDatabase(type: let type):
			return "failedToUpdateDatabase type: \(type)"
		case .failedToAdd(type: let type):
			return "failedToAddToDatabase type: \(type)"
		case .failedToDelete(type: let type):
			return "failedToAddToDelete type: \(type)"
		}
	}
}
