//
//  SunEvent+CoreDataProperties.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 13.12.23.
//
//

import Foundation
import CoreData


extension CDSunEvent {
    @NSManaged public var type: String
    @NSManaged public var latitude: Double
    @NSManaged public var longtitude: Double
    @NSManaged public var timeStart: Date
    @NSManaged public var timeFinal: Date?
    @NSManaged public var journey: CDJourney?
}
