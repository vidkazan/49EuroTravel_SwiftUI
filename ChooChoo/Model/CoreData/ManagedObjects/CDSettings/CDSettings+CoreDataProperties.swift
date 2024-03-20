//
//  Settings+CoreDataProperties.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 21.11.23.
//
//

import Foundation
import CoreData


extension ChooSettings {
	@NSManaged public var onboarding: Bool
    @NSManaged public var isWithTransfers: Bool
    @NSManaged public var transferTime: Int16
    @NSManaged public var transportModeSegment: Int16
	@NSManaged public var legViewMode: Int16
    @NSManaged public var transportModes: TransportModes
	@NSManaged public var transferCount: String?
    @NSManaged public var user: CDUser?
}
