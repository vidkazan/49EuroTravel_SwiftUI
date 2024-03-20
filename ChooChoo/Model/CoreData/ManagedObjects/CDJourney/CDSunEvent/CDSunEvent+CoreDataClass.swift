//
//  SunEvent+CoreDataClass.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 13.12.23.
//
//

import Foundation
import CoreData
import CoreLocation
import SwiftUI

@objc(CDSunEvent)
public class CDSunEvent: NSManagedObject {

}

extension CDSunEvent {
	func sunEvent() -> SunEvent {
		SunEvent(
			type: SunEventType(rawValue: self.type) ?? .day,
			location: CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longtitude),
			timeStart: self.timeStart,
			timeFinal: self.timeFinal
		)
	}
}

extension CDSunEvent {
	convenience init(context : NSManagedObjectContext,sun : SunEvent,for journey : CDJourney){
		self.init(entity: CDSunEvent.entity(), insertInto: context)
		self.latitude = sun.location.latitude
		self.longtitude = sun.location.longitude
		self.timeFinal = sun.timeFinal
		self.timeStart = sun.timeStart
		self.type = sun.type.rawValue
		self.journey = journey
	}
}
