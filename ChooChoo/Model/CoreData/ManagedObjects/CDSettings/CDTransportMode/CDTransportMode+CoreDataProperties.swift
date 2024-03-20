//
//  TransportMode+CoreDataProperties.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 21.11.23.
//
//

import Foundation
import CoreData

extension TransportModes {
	@NSManaged public var national: Bool
	@NSManaged public var nationalExpress: Bool
	@NSManaged public var regionalExpress: Bool
	@NSManaged public var regional: Bool
	@NSManaged public var suburban: Bool
	@NSManaged public var bus: Bool
	@NSManaged public var ferry: Bool
	@NSManaged public var subway: Bool
	@NSManaged public var tram: Bool
	@NSManaged public var taxi: Bool
    @NSManaged public var chooSettings: CDSettings?
}

extension TransportModes {
	func products() -> Products {
		return Products(
			nationalExpress: self.nationalExpress,
			national: self.national,
			regionalExpress: self.regionalExpress,
			regional: self.regional,
			suburban: self.suburban,
			bus: self.bus,
			ferry: self.ferry,
			subway: self.subway,
			tram: self.tram,
			taxi: self.taxi
		)
	}
}
