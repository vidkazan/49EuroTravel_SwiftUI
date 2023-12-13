//
//  ChewLineType.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 13.12.23.
//

import Foundation

import CoreData

@objc(ChewLineType)
class ChewLineType: NSManagedObject {
	@NSManaged var caseType: String

	enum CaseType: String {
		case nationalExpress
		case national
		case regionalExpress
		case regional
		case suburban
		case bus
		case ferry
		case subway
		case tram
		case taxi
		case transfer
		case foot
	}

	var lineType: LineType {
		get {
			return LineType(rawValue: self.caseType)
		}
		set {
			caseType = newValue.rawValue
		}
	}
}
