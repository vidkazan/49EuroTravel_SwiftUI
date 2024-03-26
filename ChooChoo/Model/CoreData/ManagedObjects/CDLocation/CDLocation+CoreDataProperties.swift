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

extension CDLocation {
	@NSManaged public var address: String?
	@NSManaged public var api_id: String?
	@NSManaged public var latitude: Double
	@NSManaged public var longitude: Double
	@NSManaged public var name: String
	@NSManaged public var functionType: Int16
	@NSManaged public var transportType: String?
	
	@NSManaged public var chewJourneyDep: CDJourney?
	@NSManaged public var chewJourneyArr: CDJourney?
	@NSManaged public var chewRecentSearchArrStop: CDRecentSearch?
	@NSManaged public var chewRecentSearchDepStop: CDRecentSearch?
	@NSManaged public var user: CDUser?
}

extension CDLocation {
	func stop() -> Stop {
		var type : LocationType?
		var stop : Stop!
		self.managedObjectContext?.performAndWait {
			type = LocationType(rawValue: self.functionType)
			stop = Stop(
				coordinates: Coordinate(
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
				 products: LineType(rawValue: self.transportType ?? "")?.products(),
				 distance: nil,
				 station: nil
			 )
			)
		}
		return stop
	}
	
	static func delete(object: CDLocation?,in context : NSManagedObjectContext) {
		guard let object = object else {
			print("📕 > delete \(Self.self): object is nil")
			return
		}
		context.delete(object)
	}
}
