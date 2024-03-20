//
//  CDLegType.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 13.12.23.
//

import Foundation
import CoreData


extension CDLegType {
	@NSManaged var caseType: String
	@NSManaged var startPointName: String?
	@NSManaged var finishPointName: String?
	@NSManaged var leg: CDLeg?
}

extension CDLegType {
	static func delete(object: CDLegType?,in context : NSManagedObjectContext) {
		guard let object = object else {
			print("📕 > delete \(Self.self): object is nil")
			return
		}
		context.delete(object)
	}
}
