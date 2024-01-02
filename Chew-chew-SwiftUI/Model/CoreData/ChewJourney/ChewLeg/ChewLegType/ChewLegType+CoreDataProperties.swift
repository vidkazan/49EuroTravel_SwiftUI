//
//  ChewLegType.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 13.12.23.
//

import Foundation
import CoreData


extension ChewLegType {
	@NSManaged var caseType: String?
	@NSManaged var startPointName: String?
	@NSManaged var finishPointName: String?
	@NSManaged var leg: ChewLeg?
}

extension ChewLegType {
	
	static func basicFetchRequest(context : NSManagedObjectContext) -> ChewLegType? {
		fetch(context: context)
	}

	static private func fetch(context : NSManagedObjectContext) -> ChewLegType? {
		do {
			if let res = try context.fetch(.init(entityName: "ChewLegType")).first as? ChewLegType {
				return res
			}
			print("📙 > basicFetchRequest \(Self.self): context.fetch: result is empty")
			return nil
		} catch {
			print("📕 > basicFetchRequest \(Self.self): context.fetch error")
			return nil
		}
	}
	
	static func delete(object: ChewLegType?,in context : NSManagedObjectContext) {
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
