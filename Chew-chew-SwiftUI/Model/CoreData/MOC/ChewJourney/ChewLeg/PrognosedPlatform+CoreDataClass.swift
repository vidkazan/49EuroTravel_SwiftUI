//
//  PrognosedPlatform+CoreDataClass.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 13.12.23.
//
//

import Foundation
import CoreData

@objc(ChewPrognosedPlatform)
public class ChewPrognosedPlatform: NSManagedObject {

}

extension ChewPrognosedPlatform {
	convenience init(insertInto context: NSManagedObjectContext,with prognosedPlatform : Prognosed<String?>, to stop :  ChewStop, type : LocationDirectionType) {
		self.init(context: context)
		
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
