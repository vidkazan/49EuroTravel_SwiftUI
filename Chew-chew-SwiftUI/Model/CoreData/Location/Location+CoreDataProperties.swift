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
	
	@NSManaged public var chewJourneyDep: ChewJourney?
	@NSManaged public var chewJourneyArr: ChewJourney?
	@NSManaged public var user: ChewUser
}

extension Location {
	// TODO: rearrange function
	func stop() -> Stop {
		let type = LocationType(rawValue: self.type)
		return Stop(
			coordinates: CLLocationCoordinate2D(
				latitude: self.latitude,
				longitude: self.longitude
			),
			type: type ?? LocationType.location,
			stopDTO: StopDTO(
				type: nil,
				id: self.api_id,
				name: self.name,
				address: self.address,
				location: nil,
				latitude: self.latitude,
				longitude: self.longitude,
				poi: LocationType.pointOfInterest == type,
				products: nil
			)
		)
	}
	
	static func createWith(user : ChewUser?,stop : Stop,using managedObjectContext: NSManagedObjectContext) {
		guard let user = user else {
			print("🔴 > create \(Self.self): : user is nil")
			return
		}
		let location = Location(context: managedObjectContext,stop: stop)
		location.user = user

		do {
			try managedObjectContext.save()
		} catch {
			let nserror = error as NSError
			print("📕 > create \(Self.self): ", nserror.localizedDescription)
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
			let res = try context.fetch(.init(entityName: "\(Self.self)")) as? [Location]
			if let res = res {
				return res
			}
			print("📙 > basicFetchRequest \(Self.self): context.fetch: result is empty")
			return nil
		} catch {
			print("📕 > basicFetchRequest \(Self.self): context.fetch error")
			return nil
		}
	}
	static func delete(object: Location?,in context : NSManagedObjectContext) {
		guard let object = object else {
			print("📕 > delete \(Self.self): object is nil")
			return
		}
		context.delete(object)

		do {
			try context.save()
			print("📗 > delete \(Self.self)")
		} catch {
			let nserror = error as NSError
			print("📕 > delete \(Self.self): ", nserror.localizedDescription)
		}
	}
}
