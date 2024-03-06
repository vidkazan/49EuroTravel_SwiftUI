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
	
	func fetchSettings() -> Settings {
		var settings : ChooSettings?
		var transferTypes = Settings.TransferTime.time(minutes: .zero)
		var transportMode = Settings.TransportMode.all
		var transferCount = Settings.TransferCountCases.unlimited
		var onboarding : Bool = true
		
		asyncContext.performAndWait {
			settings = user?.chooSettings
			guard let settings = settings else {
				return
			}
			transferTypes = {
				 if settings.isWithTransfers == false {
					 return .direct
				 }
				return .time(
					minutes: Settings.transferDurationCases(count: settings.transferTime)
				)
			 }()
			if let mode = Settings.TransportMode(rawValue: Int(settings.transportModeSegment)) {
				transportMode = mode
			}
			onboarding = settings.onboarding
			if let a = settings.transferCount,
			   let b = Settings.TransferCountCases(
				rawValue: a) {
				transferCount = b
			}
		}
		
		guard settings != nil else {
			return Settings()
		}
		
		let transportModes = fetchSettingsTransportModes()
		
		return Settings(
			onboarding: onboarding,
			customTransferModes: transportModes,
			transportMode: transportMode,
			transferTime: transferTypes,
			transferCount: transferCount,
			accessiblity: .partial,
			walkingSpeed: .fast,
			language: .english,
			debugSettings: Settings.ChewDebugSettings(prettyJSON: false,alternativeSearchPage: false),
			startWithWalking: true,
			withBicycle: false
		)
	}
	
	func fetchSettingsTransportModes() -> Set<LineType> {
		var modes : TransportModes!
		var transportModes = Set<LineType>()
		asyncContext.performAndWait {
			modes = user?.chooSettings?.transportModes
		
		
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
		var stops = [Stop]()
		if let chewStops = fetch(Location.self) {
			asyncContext.performAndWait {
				chewStops.forEach {
					if $0.user != nil {
						stops.append($0.stop())
					}
				}
			}
			return stops
		}
		return nil
	}
	
	func fetchRecentSearches() -> [RecentSearchesViewModel.RecentSearch]? {
		if let res = fetch(ChewRecentSearch.self)  {
			var stops = [RecentSearchesViewModel.RecentSearch]()
			asyncContext.performAndWait {
				res.forEach {
					if let dep = $0.depStop?.stop(),
						let arr = $0.arrStop?.stop(),
					   let ts = $0.searchDate?.timeIntervalSince1970 {
						stops.append(RecentSearchesViewModel.RecentSearch(
							depStop: dep,
							arrStop: arr,
							searchTS: ts
						))
					}
				}
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
		if let res = fetch(t), !res.isEmpty {
			return res
		}
		 asyncContext.performAndWait {
			self.user = ChewUser.createWith(date: .now, using: self.asyncContext)
		}
		return fetch(t)
	}
	
	func fetch<T : NSManagedObject>(_ t : T.Type) -> [T]? {
		var object : [T]? = nil
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
				object = []
				print("📙 > basicFetchRequest \(T.self): result is empty")
			} catch {
				print("📕 > basicFetchRequest \(T.self): error")
			}
		}
		return object
	}
}
