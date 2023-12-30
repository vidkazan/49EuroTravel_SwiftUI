//
//  SunEvent+CoreDataProperties.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 13.12.23.
//
//

import Foundation
import CoreData


extension ChewSunEvent {
    @NSManaged public var type: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longtitude: Double
    @NSManaged public var timeStart: Date?
    @NSManaged public var timeFinal: Date?
    @NSManaged public var journey: ChewJourney?
}

extension ChewSunEvent : Identifiable {
	static func basicFetchRequest(context : NSManagedObjectContext) -> [ChewSunEvent]? {
		fetch(context: context)
	}

	static private func fetch(context : NSManagedObjectContext) -> [ChewSunEvent]? {
		do {
			if let res = try context.fetch(.init(entityName: "\(Self.self)")) as? [ChewSunEvent] {
				return res
			}
			print("📙 > basicFetchRequest \(Self.self): context.fetch: result is empty")
			return nil
		} catch {
			print("📕 > basicFetchRequest \(Self.self): context.fetch error")
			return nil
		}
	}
	
	static func updateWith(
		of obj : ChewSunEvent?,
		with sun : SunEvent,
		using managedObjectContext: NSManagedObjectContext
	) {
		guard let obj = obj else { return }
		
		obj.latitude = sun.location.latitude
		obj.longtitude = sun.location.longitude
		obj.timeFinal = sun.timeFinal
		obj.timeStart = sun.timeStart
		obj.type = sun.type.rawValue
		
		do {
			try managedObjectContext.save()
		} catch {
			let nserror = error as NSError
			print("📕 > update \(Self.self): fialed to update", nserror.localizedDescription)
		}
	}
	
	static func delete(object: ChewSunEvent?,in context : NSManagedObjectContext) {
		guard let object = object else {
			print("📕 > delete \(Self.self): object is nil")
			return
		}
		context.delete(object)

//		do {
//			try context.save()
//			print("📗 > delete \(Self.self)")
//		} catch {
//			let nserror = error as NSError
//			print("📕 > delete \(Self.self): ", nserror.localizedDescription)
//		}
	}
}
