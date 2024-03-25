//
//  CDAppSettings+CoreDataProperties.swift
//  ChooChoo
//
//  Created by Dmitrii Grigorev on 22.03.24.
//
//

import Foundation
import CoreData


extension CDAppSettings {
	@NSManaged public var user: CDUser?
    @NSManaged public var legViewMode: Int16
	@NSManaged public var tipsToShow: Data?
}
