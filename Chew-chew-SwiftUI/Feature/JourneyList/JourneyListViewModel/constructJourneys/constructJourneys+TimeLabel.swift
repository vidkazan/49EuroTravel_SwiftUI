//
//  constructJourneyData+TimeLabel.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//

import Foundation

extension JourneyViewDataConstructor {
	static func getTimeLabelPosition(firstTS : Date?, lastTS: Date?, currentTS: Date?) -> Double? {
		guard let firstTS = firstTS, let lastTS = lastTS, let currentTS = currentTS else { return nil }
		let fTs = firstTS.timeIntervalSince1970
		let lTs = lastTS.timeIntervalSince1970
		let cTs = currentTS.timeIntervalSince1970
		let res = (cTs - fTs) / (lTs - fTs)
		return res > 0 ? ( res > 1 ? 1 : res ) : 0
	}
	
	static func getTimeLabelPosition(firstTS : Double?, lastTS: Double?, currentTS: Double?) -> Double? {
		guard let firstTS = firstTS, let lastTS = lastTS, let currentTS = currentTS else { return nil }
		let fTs = firstTS
		let lTs = lastTS
		let cTs = currentTS
		let res = (cTs - fTs) / (lTs - fTs)
		return res > 0 ? ( res > 1 ? 1 : res ) : 0
	}
	
	private func constructTimelineTimelabelData(firstTS: Date?,lastTS: Date?,currentTS: Date?) -> TimelineTimeLabelData? {
		guard let firstTS = firstTS, let lastTS = lastTS, let currentTS = currentTS else { return nil }
		let tl = TimelineTimeLabelData(
			text: DateParcer.getTimeStringFromDate(date: currentTS) ?? "time",
			textCenterYposition: JourneyViewDataConstructor.getTimeLabelPosition(
				   firstTS: firstTS,
				   lastTS: lastTS,
				   currentTS: currentTS) ?? 0
		)
		return tl
	}
}
