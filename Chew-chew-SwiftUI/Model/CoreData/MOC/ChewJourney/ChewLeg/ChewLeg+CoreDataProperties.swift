//
//  ChewLeg+CoreDataProperties.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 13.12.23.
//
//

import Foundation
import CoreData


extension ChewLeg {
    @NSManaged public var isReachable: Bool
    @NSManaged public var legTopPosition: Double
    @NSManaged public var legBottomPosition: Double
    @NSManaged public var lineName: String
    @NSManaged public var lineShortName: String
    @NSManaged public var lineType: String
    @NSManaged public var time: ChewTime
	@NSManaged public var journey: ChewJourney?
	@NSManaged public var chewLegType: ChewLegType
	@NSManaged public var stops: [ChewStop]
}
