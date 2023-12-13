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
}
