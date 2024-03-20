//
//  CDLegType.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 13.12.23.
//

import Foundation
import CoreData

@objc(CDLegType)
public class CDLegType: NSManagedObject {

	enum CaseType: String {
		case footStart
		case footMiddle
		case footEnd
		case transfer
		case line
	}

	var legType: LegViewData.LegType? {
		get {
			switch caseType {
			case "footStart":
				return .footStart(startPointName: startPointName ?? "")
			case "footMiddle":
				return .footMiddle
			case "footEnd":
				return .footEnd(finishPointName: finishPointName ?? "")
			case "transfer":
				return .transfer
			case "line":
				return .line
			default:
				return nil
			}
		}
		set {
			switch newValue {
			case .footStart(let startPointName):
				self.caseType = CaseType.footStart.rawValue
				self.finishPointName = nil
				self.startPointName = startPointName
			case .footMiddle:
				self.caseType = CaseType.footMiddle.rawValue
				self.startPointName = nil
				self.finishPointName = nil
			case .footEnd(let finishPointName):
				self.caseType = CaseType.footEnd.rawValue
				self.finishPointName = finishPointName
				self.startPointName = nil
			case .transfer:
				self.caseType = CaseType.transfer.rawValue
				self.startPointName = nil
				self.finishPointName = nil
			case .line:
				self.caseType = CaseType.line.rawValue
				self.startPointName = nil
				self.finishPointName = nil
			case .none:
				self.caseType = ""
				self.startPointName = nil
				self.finishPointName = nil
			}
		}
	}
}

extension CDLegType {
	convenience init(insertIntoManagedObjectContext context: NSManagedObjectContext, type : LegViewData.LegType, for leg : CDLeg) {
		self.init(entity: CDLegType.entity(), insertInto: context)
		self.legType = type
		self.leg = leg
	}
}

