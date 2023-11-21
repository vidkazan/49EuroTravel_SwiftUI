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
    @NSManaged public var settings: Settings
	
	static func createWith(
		modes : Set<LineType>,
		in settings : Settings,
		using managedObjectContext: NSManagedObjectContext
	) {
		let item = TransportModes(context: managedObjectContext)
		item.bus = modes.contains(.bus)
		item.ferry = modes.contains(.ferry)
		item.national = modes.contains(.national)
		item.nationalExpress = modes.contains(.nationalExpress)
		item.regional = modes.contains(.regional)
		item.regionalExpress = modes.contains(.regionalExpress)
		item.suburban = modes.contains(.suburban)
		item.subway = modes.contains(.subway)
		item.taxi = modes.contains(.taxi)
		item.tram = modes.contains(.tram)
		item.settings = settings
		
		do {
			try managedObjectContext.save()
		} catch {
			let nserror = error as NSError
			print("🔴 > save TransportModes: fialed to save new TransportModes", nserror.localizedDescription)
		}
	}
}
