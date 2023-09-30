//
//  constructJourneys+Leg.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//

import Foundation
import SwiftUI

extension JourneyViewDataConstructor {
	func constructLegType(leg : Leg, legs: [Leg]) -> LegType {
		if let dist = leg.distance {
			switch legs.firstIndex(of: leg) {
			case 0:
				return .footStart(startPointName: leg.origin?.name ?? (leg.origin?.address ?? "Origin"))
			case legs.count - 1 :
				return .footEnd(finishPointName: leg.destination?.name ?? (leg.destination?.address ?? "Destination"))
			default:
				return .footMiddle
			}
		}
		return .line
	}
}
