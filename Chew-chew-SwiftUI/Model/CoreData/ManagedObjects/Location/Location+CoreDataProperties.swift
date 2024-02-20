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
	@NSManaged public var transportType: String?
	
	@NSManaged public var chewJourneyDep: ChewJourney?
	@NSManaged public var chewJourneyArr: ChewJourney?
	@NSManaged public var chewRecentSearchArrStop: ChewRecentSearch?
	@NSManaged public var chewRecentSearchDepStop: ChewRecentSearch?
	@NSManaged public var user: ChewUser?
}

extension Location {
	// TODO: rearrange locations by calling time
	func stop() -> Stop {
		var type : LocationType?
		var stop : Stop!
		self.managedObjectContext?.performAndWait {
			type = LocationType(rawValue: self.type)
			stop = Stop(
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
				 products: LineType(rawValue: self.transportType ?? "")?.products(),
				 distance: nil,
				 station: nil
			 )
			)
		}
		return stop
	}
	
	static func delete(object: Location?,in context : NSManagedObjectContext) {
		guard let object = object else {
			print("📕 > delete \(Self.self): object is nil")
			return
		}
		context.delete(object)
	}
}
