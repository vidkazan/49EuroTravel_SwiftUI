//
//  constructJourneyList+Badges.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 12.09.23.
//

import Foundation

func constructBadges(remarks : [RemarkViewData],isReachable : Bool ) -> [Badges] {
	var badges : [Badges] = []
	let rems = remarks.filter({$0.type == .status})
	if !rems.isEmpty {
		badges.append(Badges.remarkImportant(remarks: rems))
	}
	if isReachable == false {
		badges.append(.connectionNotReachable)
	}
	
	return badges
}
