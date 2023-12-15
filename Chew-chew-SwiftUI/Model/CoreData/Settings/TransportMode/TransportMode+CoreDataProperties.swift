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
	
	static func updateWith(
		with modes : Set<LineType>,
		using managedObjectContext: NSManagedObjectContext,
		settings : Settings?,
		object transportModes : TransportModes
	) {
		guard let settings = settings else {
			return
		}
		saveSettings(item: transportModes, modes: modes, settings: settings, managedObjectContext: managedObjectContext)
	}
	
	private static func saveSettings(item : TransportModes, modes : Set<LineType>, settings : Settings, managedObjectContext : NSManagedObjectContext) {
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
			print("📗 > saved \(Self.self)")
		} catch {
			let nserror = error as NSError
			print("📕 > save \(Self.self): fialed to save", nserror.localizedDescription)
		}
	}
	
	static func createWith(
		modes : Set<LineType>,
		in settings : Settings,
		using managedObjectContext: NSManagedObjectContext
	) {
		let item = TransportModes(context: managedObjectContext)
		saveSettings(item: item, modes: modes, settings: settings, managedObjectContext: managedObjectContext)
		print("📙 > create \(Self.self): created new")
	}
	
	
	static func basicFetchRequest(
		modes : Set<LineType>,
		in settings : Settings,
		using context: NSManagedObjectContext
	) -> TransportModes? {
		if let res = fetch(context: context) {
			return res
		}
		TransportModes.createWith(modes: modes, in: settings, using: context)
		return fetch(context: context)
	}
	
	static private func fetch(context : NSManagedObjectContext) -> TransportModes? {
		do {
			let res = try context.fetch(.init(entityName: "\(Self.self)")).first as? TransportModes
			if let res = res {
				print("📗 > basicFetchRequest \(Self.self)")
				return res
			}
			print("📙 > basicFetchRequest \(Self.self): context.fetch: result is empty")
			return nil
		} catch {
			print("📕 > basicFetchRequest \(Self.self): context.fetch error")
			return nil
		}
	}
	static func delete(object: TransportModes?,in context : NSManagedObjectContext) {
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
