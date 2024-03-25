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
		var legViewMode : AppSettings.LegViewMode = .all
		var tips = Set<AppSettings.ChooTipType>()
		
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
		
		guard settings != nil else {
			return nil
		}
		
		return AppSettings(
			debugSettings: .init(prettyJSON: false, alternativeSearchPage: false),
			legViewMode: legViewMode,
			tips: tips
		)
	}
	
	func fetchSettings() -> JourneySettings {
		var settings : CDJourneySettings?
		var modesData : Data?
		var transferTypes = JourneySettings.TransferTime.time(minutes: .zero)
		var transportMode = JourneySettings.TransportMode.all
		var transferCount = JourneySettings.TransferCountCases.unlimited
		var customTransferModes = Set<LineType>()
		
		asyncContext.performAndWait {
			settings = user?.journeySettings
			guard let settings = settings else {
				return
			}
			modesData = settings.transportModes
			transferTypes = {
				 if settings.isWithTransfers == false {
					 return .direct
				 }
				return .time(
					minutes: JourneySettings.transferDurationCases(count: settings.transferTime)
				)
			 }()
			if let mode = JourneySettings.TransportMode(rawValue: Int(settings.transportModeSegment)) {
				transportMode = mode
			}
			if let a = settings.transferCount,
			   let b = JourneySettings.TransferCountCases(
				rawValue: a) {
				transferCount = b
			}
		}
		
		guard settings != nil else {
			return JourneySettings()
		}
		
		
		if let modes = modesData,
		   let modesDecoded = try? JSONDecoder().decode(Set<LineType>.self, from: modes) {
			customTransferModes = modesDecoded
		}
	
		return JourneySettings(
			customTransferModes: customTransferModes,
			transportMode: transportMode,
			transferTime: transferTypes,
			transferCount: transferCount,
			accessiblity: .partial,
			walkingSpeed: .fast,
			startWithWalking: true,
			withBicycle: false
		)
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
	
	
	private func fetchOrCreateUser() -> [CDUser]? {
		if let res = fetch(CDUser.self), !res.isEmpty {
			return res
		}
		 asyncContext.performAndWait {
			self.user = CDUser.createWith(date: .now, using: self.asyncContext)
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
