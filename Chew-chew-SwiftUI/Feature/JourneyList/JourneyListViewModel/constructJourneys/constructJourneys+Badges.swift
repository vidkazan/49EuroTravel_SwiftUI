//
//  constructJourneys+Badges.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 12.09.23.
//

import Foundation

	func constructBadges(remarks : [Remark],isReachable : Bool ) -> [Badges] {
		var res : [Badges] = []
		let rems = remarks.filter({$0.type == "status"})
		if !rems.isEmpty {
			res.append(Badges.alertFromRemark)
		}
		if isReachable == false {
			res.append(.connectionNotReachable)
		}
		res.append(Badges.dticket)
		
		return res
	}
