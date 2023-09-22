//
//  ConstructJourneyData+Journey.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//
import Foundation
import CoreLocation
import UIKit


extension JourneyListViewModel {
	func constructTransferCount(legs : [LegViewData]) -> Int {
		return legs.filter { leg in
			if case .line = leg.legType { return true }
			return false
		}.count - 1
	}
}
