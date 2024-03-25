//
//  CoreDataStore.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 07.01.24.
//

import Foundation
import CoreData
import CoreLocation

// MARK: remove
extension CoreDataStore {
	func deleteJourneyIfFound(id : Int64) -> Bool {
		var result = false
		if let objects = self.fetchJourneys() {
			 asyncContext.performAndWait {
				if let res = objects.first(where: { obj in
					return obj.id == id
				}) {
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
		
		if let objects = self.fetch(CDLocation.self) {
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
		if let objects = self.fetch(CDRecentSearch.self) {
			 asyncContext.performAndWait {
				if let res = objects.first(where: { obj in
					return obj.id == id
				}) {
					self.asyncContext.delete(res)
					self.saveAsyncContext()
					result = true
				}
			}
		}
		return result
	}
}
