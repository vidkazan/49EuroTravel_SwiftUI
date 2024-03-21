//
//  PrognosedPlatform+CoreDataClass.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 13.12.23.
//
//

import Foundation
import CoreData

@objc(CDPrognosedPlatform)
public class CDPrognosedPlatform: NSManagedObject {

}

extension CDPrognosedPlatform {
	convenience init(insertInto context: NSManagedObjectContext,with prognosedPlatform : Prognosed<String>, to stop :  CDStop, type : LocationDirectionType) {
		self.init(entity: CDPrognosedPlatform.entity(), insertInto: context)
		
		self.planned = prognosedPlatform.planned
		self.actual = prognosedPlatform.actual
		
		switch type {
		case .departure:
			self.departureStop = stop
		case .arrival:
			self.arrivalStop = stop
		}
	}
}
