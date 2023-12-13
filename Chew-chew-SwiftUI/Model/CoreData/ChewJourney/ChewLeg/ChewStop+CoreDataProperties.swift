//
//  ChewStop+CoreDataProperties.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 13.12.23.
//
//

import Foundation
import CoreData


extension ChewStop {
    @NSManaged public var lat: Double
    @NSManaged public var long: Double
    @NSManaged public var name: String
    @NSManaged public var type: String
    @NSManaged public var time: ChewTime
    @NSManaged public var depPlatform: ChewPrognosedPlatform?
    @NSManaged public var arrPlatform: ChewPrognosedPlatform?
	@NSManaged public var leg: ChewLeg?
	@NSManaged public var isCancelled: Bool

}

extension ChewStop : Identifiable {

}
