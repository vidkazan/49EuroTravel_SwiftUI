//
//  CoreDataStore.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 07.01.24.
//

import Foundation
import CoreData
import CoreLocation

// MARK: add
extension CoreDataStore {
	func addRecentLocation(stop : Stop){
		guard let user = self.user else { return }
		 asyncContext.performAndWait {
			 if stop.stopDTO?.products != nil {
				 let _ = CDLocation(
					context: self.asyncContext,
					stop: stop,
					parent: .recentLocation(user)
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
			let _ = CDJourney(
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
			let _ = CDRecentSearch(
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
