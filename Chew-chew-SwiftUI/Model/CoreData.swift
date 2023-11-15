//
//  CoreDataClass.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 12.11.23.
//

import CoreData

// MARK: DataProperties
extension Item {
	
	static func createWith(date : Date,using managedObjectContext: NSManagedObjectContext) {
		
		let launch = Item(context: managedObjectContext)
		launch.timestamp = date
		do {
			try managedObjectContext.save()
		} catch {
			let nserror = error as NSError
			print("🔴 > save Item: fialed to save new Item", nserror.localizedDescription)
		}
	}
	
	static func basicFetchRequest(context : NSManagedObjectContext) -> Item? {
		do {
			let res = try context.fetch(.init(entityName: "Item")).first as? Item
			if let res = res {
				return res
			}
			print("🔴 > basicFetchRequest: context.fetch: result is empty")
			return nil
		} catch {
			print("🔴 > basicFetchRequest: context.fetch error")
			return nil
		}
	}
}
