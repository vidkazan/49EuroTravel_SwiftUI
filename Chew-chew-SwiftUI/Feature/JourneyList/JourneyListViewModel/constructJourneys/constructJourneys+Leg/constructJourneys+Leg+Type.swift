//
//  constructJourneys+Leg.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//

import Foundation
import UIKit
import SwiftUI

extension JourneyListViewModel {
	func constructLegType(leg : Leg, legs: [Leg]) -> LegType {
		if let dist = leg.distance {
			switch legs.firstIndex(of: leg) {
			case 0:
				return .foot(distance: dist, place: .atStart(startPointName: leg.origin?.name ?? (leg.origin?.address ?? "Origin")))
			case legs.count - 1 :
				return .foot(distance: dist, place: .atFinish(finishPointName: leg.destination?.name ?? (leg.destination?.address ?? "Destination")))
			default:
				return .foot(distance: dist, place: .inBetween)
			}
		}
		if let line = leg.line, let mode = line.mode, let name = line.name {
			return .line(mode: mode, name: name)
		}
		return .line(mode: "wtf", name: "???")
	}
}
