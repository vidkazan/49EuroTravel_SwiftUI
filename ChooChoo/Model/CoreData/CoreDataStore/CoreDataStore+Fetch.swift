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
	func fetchUser() -> CDUser? {
		let user = self.fetchOrCreate(entity: .user, CDUser.self)?.first
		self.user = user
		return user
	}
	
	func fetchSettings() -> Settings {
		var settings : CDSettings?
		var transferTypes = Settings.TransferTime.time(minutes: .zero)
		var transportMode = Settings.TransportMode.all
		var transferCount = Settings.TransferCountCases.unlimited
		var onboarding : Bool = true
		var legViewMode : Settings.LegViewMode = .sunEvents
		
		asyncContext.performAndWait {
			settings = user?.chooSettings
			guard let settings = settings else {
				return
			}
			if let mode = Settings.LegViewMode(rawValue: settings.legViewMode) {
				legViewMode = mode
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
			customTransferModes: transportModes,
			transportMode: transportMode,
			transferTime: transferTypes,
			transferCount: transferCount,
			accessiblity: .partial,
			walkingSpeed: .fast,
			language: .english,
			startWithWalking: true,
			withBicycle: false,
			onboarding: onboarding,
			debugSettings: Settings.ChewDebugSettings(
				prettyJSON: false,
				alternativeSearchPage: false
			),
			legViewMode: legViewMode
		)
	}
	
	func fetchSettingsTransportModes() -> Set<LineType> {
		var modes : CDTransportModes!
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
		if let chewStops = fetch(CDLocation.self) {
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
		if let res = fetch(CDRecentSearch.self)  {
			var stops = [RecentSearchesViewModel.RecentSearch]()
			asyncContext.performAndWait {
				res.forEach {
					if
						let dep = $0.depStop?.stop(),
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
	
	func fetchJourneys() -> [CDJourney]? {
		fetch(CDJourney.self)
	}
	
	
	private func fetchOrCreate<T : NSManagedObject>(
		entity : CoreDataStore.Entities,
		_ t : T.Type
	) -> [T]? {
		if let res = fetch(t), !res.isEmpty {
			return res
		}
		 asyncContext.performAndWait {
			self.user = CDUser.createWith(date: .now, using: self.asyncContext)
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
