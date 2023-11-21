//
//  SavedJourney+CoreDataProperties.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 21.11.23.
//
//

import Foundation
import CoreData


extension SavedJourney {

    @NSManaged public var journeyRef: String?
    @NSManaged public var arrivalStop: Location?
    @NSManaged public var departureStop: Location?
	@NSManaged public var user: ChewUser

}

extension SavedJourney : Identifiable {

}
