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
	static func delete(object: ChewPrognosedPlatform?,in context : NSManagedObjectContext) {
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
