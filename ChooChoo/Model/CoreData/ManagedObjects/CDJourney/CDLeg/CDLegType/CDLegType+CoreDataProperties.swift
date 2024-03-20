//
//  ChewLegType.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 13.12.23.
//

import Foundation
import CoreData


extension ChewLegType {
	@NSManaged var caseType: String
	@NSManaged var startPointName: String?
	@NSManaged var finishPointName: String?
	@NSManaged var leg: ChewLeg?
}

extension ChewLegType {
	static func delete(object: ChewLegType?,in context : NSManagedObjectContext) {
		guard let object = object else {
			print("📕 > delete \(Self.self): object is nil")
			return
		}
		context.delete(object)
	}
}
