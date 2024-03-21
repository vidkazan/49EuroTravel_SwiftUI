//
//  CDStop+CoreDataClass.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 13.12.23.
//
//

import Foundation
import CoreData
import CoreLocation

@objc(CDStop)
public class CDStop: NSManagedObject {

}

extension CDStop {
	convenience init(insertInto context: NSManagedObjectContext,with stopData : StopViewData, to leg :  CDLeg) {
		self.init(entity: CDStop.entity(), insertInto: context)
		self.stopId = stopData.id
		self.lat = stopData.locationCoordinates.latitude
		self.long = stopData.locationCoordinates.longitude
		self.name = stopData.name
		self.stopOverType = stopData.stopOverType.rawValue
		self.isCancelled = stopData.cancellationType() == .fullyCancelled
		self.leg = leg
		
		let _ = CDTime(
			context: context,
			container: stopData.time,
			cancelled: stopData.cancellationType() == .fullyCancelled,
			for: self
		)
		
		let _ = CDPrognosedPlatform(insertInto: context, with: stopData.departurePlatform, to: self, type: .departure)
		let _ = CDPrognosedPlatform(insertInto: context, with: stopData.arrivalPlatform, to: self, type: .arrival)
	}
}

extension CDStop {
	func stopViewData() -> StopViewData {
		let time = TimeContainer(chewTime: self.time)
		return StopViewData(
			id: self.stopId,
			locationCoordinates: CLLocationCoordinate2D(latitude: self.lat, longitude: self.long),
			name: self.name,
			departurePlatform: Prognosed<String>(actual: self.depPlatform?.actual, planned: self.depPlatform?.planned),
			arrivalPlatform: Prognosed<String>(actual: self.arrPlatform?.actual, planned: self.arrPlatform?.planned),
			time: time,
			stopOverType: StopOverType(rawValue: self.stopOverType) ?? .stopover
		)
	}
}
