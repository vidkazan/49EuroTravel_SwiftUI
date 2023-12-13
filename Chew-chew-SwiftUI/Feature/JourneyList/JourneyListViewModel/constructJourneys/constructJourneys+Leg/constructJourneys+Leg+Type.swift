//
//  constructJourneyList+Leg.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//

import Foundation
import SwiftUI

func constructLegType(leg : LegDTO, legs: [LegDTO]?) -> LegViewData.LegType {
	if leg.distance != nil, let legs = legs {
		switch legs.firstIndex(of: leg) {
		case 0:
			return .footStart(startPointName: leg.origin?.name ?? (leg.origin?.address ?? "Origin(legType)"))
		case legs.count - 1 :
			return .footEnd(finishPointName: leg.destination?.name ?? (leg.destination?.address ?? "Destination(legType)"))
		default:
			return .footMiddle
		}
	}
	return .line
}
