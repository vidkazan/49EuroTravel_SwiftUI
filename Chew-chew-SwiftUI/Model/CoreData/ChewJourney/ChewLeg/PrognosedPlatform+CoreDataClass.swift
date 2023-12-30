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
		
		do {
			try context.save()
		} catch {
			let nserror = error as NSError
			print("📕 > save \(Self.self): failed to save new ", nserror.localizedDescription)
		}
	}
}

extension ChewPrognosedPlatform {
	static func updateWith(
		of obj : ChewPrognosedPlatform?,
		with : Prognosed<String?>,
		using managedObjectContext: NSManagedObjectContext
	) {
		guard let obj = obj else { return }
		
		obj.planned = with.planned
		obj.actual = with.actual
		
		do {
			try managedObjectContext.save()
		} catch {
			let nserror = error as NSError
			print("📕 > update \(Self.self): fialed to update", nserror.localizedDescription)
		}
	}
}
