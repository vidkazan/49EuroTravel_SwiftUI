//
//  CoreDataStore.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 07.01.24.
//

import Foundation
import CoreData
import CoreLocation


// MARK: Fetch
extension CoreDataStore {
	func fetchUser() -> ChewUser? {
		let user = self.fetchOrCreate(entity: .user, ChewUser.self)?.first
		self.user = user
		return user
	}
	
	func fetchSettings() -> ChewSettings {
		var settings : Settings?
		var transferTypes : ChewSettings.TransferTime!
		var transportMode : ChewSettings.TransportMode!
		 asyncContext.performAndWait {
			settings = user?.settings
			 transferTypes = {
				 if settings?.isWithTransfers == false {
					 return .direct
				 }
				 return .time(minutes: Int(settings?.transferTime ?? 0))
			 }()
			 transportMode = ChewSettings.TransportMode(rawValue: Int(settings?.transportModeSegment ?? 0))
		}
		guard settings != nil else { return ChewSettings() }
		let transportModes = fetchTransportModes()
		
		return ChewSettings(
			customTransferModes: transportModes,
			transportMode: transportMode,
			transferTime: transferTypes,
			accessiblity: .partial,
			walkingSpeed: .fast,
			language: .english,
			debugSettings: ChewSettings.ChewDebugSettings(prettyJSON: false),
			startWithWalking: true,
			withBicycle: false
		)
	}
	
	func fetchTransportModes() -> Set<LineType> {
		var modes : TransportModes!
		var transportModes = Set<LineType>()
		asyncContext.performAndWait {
			modes = user?.settings?.transportModes
		
		
		// buuueeeeeeee
		if modes.bus { transportModes.insert(.bus) }
		if modes.ferry { transportModes.insert(.ferry) }
		if modes.national { transportModes.insert(.national) }
		if modes.nationalExpress { transportModes.insert(.nationalExpress) }
		if modes.regional { transportModes.insert(.regional) }
		if modes.regionalExpress { transportModes.insert(.regionalExpress) }
		if modes.suburban { transportModes.insert(.suburban) }
		if modes.subway { transportModes.insert(.subway) }
		if modes.taxi { transportModes.insert(.taxi) }
		if modes.tram { transportModes.insert(.tram) }
		}
		return transportModes
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
		 asyncContext.performAndWait {
			self.user = ChewUser.createWith(date: .now, using: self.asyncContext)
		}
		return fetch(t)
	}
	
	func fetch<T : NSManagedObject>(_ t : T.Type) -> [T]? {
		var object : [T]? = [T]()
		 asyncContext.performAndWait {
			guard let fetchRequest = T.fetchRequest() as? NSFetchRequest<T> else {
				print("📕 > basicFetchRequest \(T.self): generate fetch request error")
				return
			}
			do {
				let res = try self.asyncContext.fetch(fetchRequest)
				if !res.isEmpty {
					print("📗 > basicFetchRequest \(T.self)")
					object = res
					return
				}
			} catch {
				print("📕 > basicFetchRequest \(T.self): error")
			}
			print("📙 > basicFetchRequest \(T.self): result is empty")
		}
		return object
	}
}
