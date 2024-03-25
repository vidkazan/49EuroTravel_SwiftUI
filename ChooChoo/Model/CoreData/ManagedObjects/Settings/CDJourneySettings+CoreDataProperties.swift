//
//  Settings+CoreDataProperties.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 21.11.23.
//
//

import Foundation
import CoreData


extension CDJourneySettings {
    @NSManaged public var isWithTransfers: Bool
    @NSManaged public var transferTime: Int16
    @NSManaged public var transportModeSegment: Int16
	#warning("CDTransportModes: change to Set<String>")
    @NSManaged public var transportModes: CDTransportModes
	@NSManaged public var transferCount: String?
    @NSManaged public var user: CDUser?
}
