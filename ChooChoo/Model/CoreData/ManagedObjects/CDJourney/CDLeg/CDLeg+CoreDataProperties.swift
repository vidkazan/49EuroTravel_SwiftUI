//
//  CDLeg+CoreDataProperties.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 13.12.23.
//
//

import Foundation
import CoreData


extension CDLeg {
	@NSManaged public var tripId: String
	@NSManaged public var legDTO: String?
    @NSManaged public var isReachable: Bool
    @NSManaged public var legTopPosition: Double
    @NSManaged public var legBottomPosition: Double
    @NSManaged public var lineName: String
    @NSManaged public var lineShortName: String
    @NSManaged public var lineType: String
	@NSManaged public var time: Data
	@NSManaged public var journey: CDJourney?
	@NSManaged public var chewLegType: CDLegType
	@NSManaged public var stops: [CDStop]
}
