//
//  TimeLabelView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 20.09.23.
//

import Foundation
import SwiftUI


extension TimeLabelView {
	init(
		size : ChewTextSize,
		arragement : Arragement,
		time : Prognosed<String>,
		delayStatus : TimeContainer.DelayStatus
	) {
		self.size = size
		self.arragement = arragement
		self.time = time
		self.delayStatus = delayStatus
	}
	
	init(
		stopOver : StopViewData,
		stopOverType : StopOverType
	) {
		self.delayStatus = stopOver.stopOverType.timeLabelViewDelayStatus(time: stopOver.time)
		self.size = stopOverType.timeLabelSize
		self.arragement = stopOverType.timeLabelArragament
		let time = stopOver.stopOverType.timeLabelViewTime(timeStringContainer: stopOver.time.stringTimeValue)
		self.time = Prognosed(actual: time.actual,planned: time.planned)
	}
	
	init(
		stopOver : StopViewData
	) {
		self.delayStatus = stopOver.stopOverType.timeLabelViewDelayStatus(time: stopOver.time)
		self.size = stopOver.stopOverType.timeLabelSize
		self.arragement = stopOver.stopOverType.timeLabelArragament
		let time = stopOver.stopOverType.timeLabelViewTime(timeStringContainer: stopOver.time.stringTimeValue)
		self.time = Prognosed(actual: time.actual,planned: time.planned)
	}
}
