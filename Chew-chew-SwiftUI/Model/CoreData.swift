//
//  CoreDataClass.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 12.11.23.
//

import CoreData
import CoreLocation

extension Location {
	static func createWith(stop : Stop,using managedObjectContext: NSManagedObjectContext) {
		let location = Location(context: managedObjectContext)
		location.id = stop.id
		location.api_id = stop.stopDTO?.id
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
	
	static func basicFetchRequest(context : NSManagedObjectContext) -> [Stop]? {
		if let res = fetch(context: context)  {
			let stops = res.map { elem in
				let type = LocationType(rawValue: elem.type)
				return Stop(
					coordinates: CLLocationCoordinate2D(
						latitude: elem.latitude,
						longitude: elem.longitude
					),
					type: type ?? LocationType.location,
					stopDTO: StopDTO(
						type: nil,
						id: elem.api_id,
						name: elem.name,
						address: elem.address,
						location: nil,
						latitude: elem.latitude,
						longitude: elem.longitude,
						poi: LocationType.pointOfInterest == type,
						products: nil
					)
				)
			}
			return stops
		}
		return nil
	}
	
	static private func fetch(context : NSManagedObjectContext) -> [Location]? {
		do {
			let res = try context.fetch(.init(entityName: "Location")) as? [Location]
			if let res = res {
				return res
			}
			print("🔴 > basicFetchRequest Location: context.fetch: result is empty")
			return nil
		} catch {
			print("🔴 > basicFetchRequest Location: context.fetch error")
			return nil
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
			print("🔴 > basicFetchRequest User: context.fetch: result is empty")
			return nil
		} catch {
			print("🔴 > basicFetchRequest User: context.fetch error")
			return nil
		}
	}
}
