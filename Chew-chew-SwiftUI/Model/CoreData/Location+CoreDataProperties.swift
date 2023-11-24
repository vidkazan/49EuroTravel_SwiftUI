//
//  Location+CoreDataProperties.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 21.11.23.
//
//

import Foundation
import CoreData
import CoreLocation

extension Location {
	@NSManaged public var address: String?
	@NSManaged public var api_id: String?
	@NSManaged public var latitude: Double
	@NSManaged public var longitude: Double
	@NSManaged public var name: String
	@NSManaged public var type: Int16
	
	@NSManaged public var savedJourneyDeparture: SavedJourney
	@NSManaged public var user: ChewUser
}

extension Location {
	static func createWith(user : ChewUser?,stop : Stop,using managedObjectContext: NSManagedObjectContext) {
		let location = Location(context: managedObjectContext)
		guard let user = user,
		let id = stop.stopDTO?.id else {
			print("🔴 > save Location: fialed to create Location: user is nil")
			return
		}
		location.api_id = id
		location.address = stop.stopDTO?.address
		location.latitude = stop.coordinates.latitude
		location.longitude = stop.coordinates.longitude
		location.name = stop.name
		location.type = stop.type.rawValue
		location.user = user

		do {
			try managedObjectContext.save()
		} catch {
			let nserror = error as NSError
			print("🔴 > save Location: fialed to create Location: ", nserror.localizedDescription)
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
