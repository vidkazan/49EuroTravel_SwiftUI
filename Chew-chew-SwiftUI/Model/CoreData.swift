//
//  CoreDataClass.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 12.11.23.
//

import CoreData

extension Location {
	static func createWith(stop : Stop,using managedObjectContext: NSManagedObjectContext) {
		
		let location = Location(context: managedObjectContext)
		location.id = stop.id
		location.address = stop.stopDTO?.address
		location.latitude = stop.coordinates.latitude
		location.longitude = stop.coordinates.longitude
		location.name = stop.name
		location.type = stop.type.rawValue
		do {
			try managedObjectContext.save()
		} catch {
			let nserror = error as NSError
			print("🔴 > save Location: fialed to create Location", nserror.localizedDescription)
		}
	}
}

// MARK: DataProperties
extension ChewUser {
	static func updateWith(date : Date,using managedObjectContext: NSManagedObjectContext, user : ChewUser?) {
		guard let user = user else {return}
		user.timestamp = date
		do {
			try managedObjectContext.save()
		} catch {
			let nserror = error as NSError
			print("🔴 > save User: fialed to update User", nserror.localizedDescription)
		}
	}
	
	
	
	static func createWith(date : Date,using managedObjectContext: NSManagedObjectContext) {
		let launch = ChewUser(context: managedObjectContext)
		launch.timestamp = date
		do {
			try managedObjectContext.save()
		} catch {
			let nserror = error as NSError
			print("🔴 > save User: fialed to save new User", nserror.localizedDescription)
		}
	}
	
	static func basicFetchRequest(context : NSManagedObjectContext) -> ChewUser? {
		if let res = fetch(context: context) {
			return res
		}
		ChewUser.createWith(date: .now, using: context)
		return fetch(context: context)
	}
	
	static private func fetch(context : NSManagedObjectContext) -> ChewUser? {
		do {
			let res = try context.fetch(.init(entityName: "ChewUser")).first as? ChewUser
			if let res = res {
				return res
			}
			print("🔴 > basicFetchRequest: context.fetch: result is empty")
			return nil
		} catch {
			print("🔴 > basicFetchRequest: context.fetch error")
			return nil
		}
	}
}
