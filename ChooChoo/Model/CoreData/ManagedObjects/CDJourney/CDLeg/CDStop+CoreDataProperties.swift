//
//  CDStop+CoreDataProperties.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 13.12.23.
//
//

import Foundation
import CoreData


extension CDStop {
    @NSManaged public var lat: Double
	@NSManaged public var stopId: String?
    @NSManaged public var long: Double
    @NSManaged public var name: String
    @NSManaged public var stopOverType: String
	@NSManaged public var locationType: Int16
	@NSManaged public var time: Data
//    @NSManaged public var time: CDTime
    @NSManaged public var depPlatform: CDPrognosedPlatform?
    @NSManaged public var arrPlatform: CDPrognosedPlatform?
	@NSManaged public var leg: CDLeg?
	@NSManaged public var isCancelled: Bool

}
