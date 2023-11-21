//
//  Settings+CoreDataProperties.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 21.11.23.
//
//

import Foundation
import CoreData


extension Settings {
    @NSManaged public var isWithTransfers: Bool
    @NSManaged public var transferTime: Int16
    @NSManaged public var transportModeSegment: Int16
    @NSManaged public var transportModes: TransportModes
    @NSManaged public var user: ChewUser
}

extension Settings {
	static func createWith(
		newSettings : ChewSettings,
		in user : ChewUser?,
		using managedObjectContext: NSManagedObjectContext) {
		guard let user = user else {
			print("🔴 > save Settings: failed to save Settings: user is nil")
			return
		}
		let settings = Settings(context: managedObjectContext)
		switch newSettings.transferTime {
		case .direct:
			settings.isWithTransfers = false
			settings.transferTime = 0
		case .time(minutes: let minutes):
			settings.isWithTransfers = true
			settings.transferTime = Int16(minutes)
		}
		
		settings.transportModeSegment = Int16(newSettings.transportMode.rawValue)
		settings.user = user
		
		do {
			try managedObjectContext.save()
			TransportModes.createWith(
				modes: newSettings.customTransferModes,
				in: settings,
				using: managedObjectContext
			)
		} catch {
			let nserror = error as NSError
			print("🔴 > save Settings: failed to save new Settings:", nserror.localizedDescription)
		}
	}
}
