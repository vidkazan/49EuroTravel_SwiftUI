//
//  ViewModel+ConstructJourneyData+Timeline.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 24.08.23.
//

import Foundation
import SwiftUI

extension OldSearchLocationViewModel {
	
	func getTimeLabelPosition(firstTS : Date?, lastTS: Date?, currentTS: Date?) -> Double?{
		guard let firstTS = firstTS, let lastTS = lastTS, let currentTS = currentTS else { return nil }
		let fTs = firstTS.timeIntervalSinceReferenceDate
		let lTs = lastTS.timeIntervalSinceReferenceDate
		let cTs = currentTS.timeIntervalSinceReferenceDate
		let ext = 0.0
		let fTsExtended = fTs - ext
		let lTsExtended = lTs + ext
		
		let diffExtended = lTsExtended - fTsExtended
		
		let cDiff = cTs - fTsExtended
		
		return cDiff / diffExtended
	}
	
	private func constructTimelineTimelabelData(firstTS: Date?,lastTS: Date?,currentTS: Date?) -> TimelineTimeLabelDataSourse? {
		guard let firstTS = firstTS, let lastTS = lastTS, let currentTS = currentTS else { return nil }
		let tl = TimelineTimeLabelDataSourse(
			text: DateParcer.getTimeStringFromDate(date: currentTS),
			   textCenterYposition: self.getTimeLabelPosition(
				   firstTS: firstTS,
				   lastTS: lastTS,
				   currentTS: currentTS)!)
		return tl
	}
	
	 func constructTimelineData(firstTS: Date?,lastTS: Date?) -> TimelineViewDataSourse? {
		let tl = TimelineViewDataSourse(timeLabels: [
			self.constructTimelineTimelabelData(firstTS: firstTS, lastTS: lastTS, currentTS: firstTS)!,
			self.constructTimelineTimelabelData(firstTS: firstTS, lastTS: lastTS, currentTS: lastTS)!
		])
		return tl
	}
}
