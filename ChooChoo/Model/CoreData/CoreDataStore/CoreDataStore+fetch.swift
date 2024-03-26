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
		let user = self.fetchOrCreateUser()?.first
		self.user = user
		return user
	}
	
	func fetchAppSettings() -> AppSettings? {
		var settings : CDAppSettings?
		var legViewMode : AppSettings.LegViewMode? = nil
		var tips : Set<AppSettings.ChooTipType>? = nil
		
		asyncContext.performAndWait {
			settings = user?.appSettings
			guard let settings = settings else {
				return
			}
			if let mode = AppSettings.LegViewMode(rawValue: settings.legViewMode) {
				legViewMode = mode
			}
			if let tipsToShowData = settings.tipsToShow,
				let res = try? JSONDecoder()
				.decode(
					Set<AppSettings.ChooTipType>.self,
					from: tipsToShowData
				) {
				tips = res
			}
		}
		
		guard let legViewMode = legViewMode, let tips = tips else {
			return nil
		}
		
		return AppSettings(
			debugSettings: .init(prettyJSON: false, alternativeSearchPage: false),
			legViewMode: legViewMode,
			tips: tips
		)
	}
	
	func fetchSettings() -> JourneySettings? {
		var settings : Data?
		
		asyncContext.performAndWait {
			settings = user?.journeySettings
		}
		
		if let settings = settings {
			return try? JSONDecoder().decode(JourneySettings.self, from: settings)
		}
		return nil
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
						let depArrStops = try? JSONDecoder().decode(DepartureArrivalPairStop.self, from: $0.depArrStops),
						let ts = $0.searchDate?.timeIntervalSince1970 {
							stops.append(RecentSearchesViewModel.RecentSearch(
								stops: depArrStops,
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
	
	
	private func fetchOrCreateUser() -> [CDUser]? {
		if let res = fetch(CDUser.self), !res.isEmpty {
			return res
		}
		 asyncContext.performAndWait {
			self.user = CDUser.createWith(using: self.asyncContext)
		}
		return fetch(CDUser.self)
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
