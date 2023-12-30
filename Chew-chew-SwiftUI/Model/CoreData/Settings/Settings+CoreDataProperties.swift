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
	static func updateWith(
		with newSettings : ChewSettings,
		using managedObjectContext: NSManagedObjectContext,
		settings : Settings?,
		transportModes : TransportModes?
	) {
		guard let settings = settings,let transportModes = transportModes else {
			print("📕 > update \(Self.self): failed : setttings / transportMode is nil")
			return
		}
		saveSettings(newSettings: newSettings, settings: settings, managedObjectContext: managedObjectContext,transportModes: transportModes)
	}
	
	
	static func createWith(
		newSettings : ChewSettings,
		in user : ChewUser?,
		using managedObjectContext: NSManagedObjectContext
	) {
		guard let user = user else {
			print("📕 > create \(Self.self): failed : user is nil")
			return
		}
		let settings = Settings(context: managedObjectContext)
		let modes = TransportModes(context: managedObjectContext)
		settings.user = user
		saveSettings(newSettings: newSettings, settings: settings, managedObjectContext: managedObjectContext,transportModes: modes)
		print("📙 > create \(Self.self): created new Settings")
	}
	
	
	private static func saveSettings(
		newSettings : ChewSettings,
		settings : Settings,
		managedObjectContext : NSManagedObjectContext,
		transportModes : TransportModes
	) {
		switch newSettings.transferTime {
		case .direct:
			settings.isWithTransfers = false
			settings.transferTime = 0
		case .time(minutes: let minutes):
			settings.isWithTransfers = true
			settings.transferTime = Int16(minutes)
		}
		
		settings.transportModeSegment = Int16(newSettings.transportMode.rawValue)
		
		do {
			TransportModes.updateWith(with: newSettings.customTransferModes, using: managedObjectContext, settings: settings, object: transportModes)
			try managedObjectContext.save()
			print("📗 > save \(Self.self): saved")
		} catch {
			let nserror = error as NSError
			print("📕 > save \(Self.self): failed to save: \(nserror)")
		}
	}
	
	static func basicFetchRequest(user : ChewUser?,context : NSManagedObjectContext) -> Settings? {
		if let res = fetch(context: context) {
			print("📗 > basicFetchRequest \(Self.self): loaded")
			return res
		}
		Settings.createWith(
			newSettings: ChewSettings(),
			in: user,
			using: context
		)
		return fetch(context: context)
	}
	
	static private func fetch(context : NSManagedObjectContext) -> Settings? {
		do {
			let res = try context.fetch(.init(entityName: "\(Self.self)")).first as? Settings
			if let res = res {
				return res
			}
			print("📙 > basicFetchRequest \(Self.self): context.fetch: result is empty")
			return nil
		} catch {
			print("📕 > basicFetchRequest \(Self.self): context.fetch error")
			return nil
		}
	}
	static func delete(object: Settings?,in context : NSManagedObjectContext) {
		guard let object = object else {
			print("📕 > delete \(Self.self): object is nil")
			return
		}
		context.delete(object)

		do {
			try context.save()
			print("📗 > delete \(Self.self)")
		} catch {
			let nserror = error as NSError
			print("📕 > delete \(Self.self): ", nserror.localizedDescription)
		}
	}
}