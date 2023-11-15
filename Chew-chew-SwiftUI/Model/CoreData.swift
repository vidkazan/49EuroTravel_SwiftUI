//
//  CoreDataClass.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 12.11.23.
//

import Foundation
import CoreData


// MARK: DataClass
@objc(ChewLocalData)
public class ChewLocalData : NSManagedObject {
}


// MARK: DataProperties
extension ChewLocalData {
	@NSManaged public var data : Date
	@NSManaged public var isFirstEntry : Bool
}

