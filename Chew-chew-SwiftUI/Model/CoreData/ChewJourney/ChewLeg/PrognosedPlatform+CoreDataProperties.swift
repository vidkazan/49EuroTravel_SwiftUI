//
//  PrognosedPlatform+CoreDataProperties.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 13.12.23.
//
//

import Foundation
import CoreData


extension ChewPrognosedPlatform {
    @NSManaged public var planned: String?
    @NSManaged public var actual: String?
    @NSManaged public var departureStop: ChewStop?
    @NSManaged public var arrivalStop: ChewStop?
}

extension ChewPrognosedPlatform : Identifiable {

}
