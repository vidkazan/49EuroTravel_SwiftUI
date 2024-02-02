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
		isSmall: Bool,
		arragement : Arragement,
		time : Prognosed<String>,
		delay: Int?,
		isCancelled : Bool
	) {
		self.delay = delay
		self.isSmall = isSmall
		self.arragement = arragement
		self.time = time
		self.isCancelled = isCancelled
	}
	
	init(
		stopOver : StopViewData,
		stopOverType : StopOverType
	) {
		self.delay = stopOver.stopOverType.timeLabelViewDelay(timeContainer: stopOver.timeContainer)
		self.isSmall = stopOverType.smallTimeLabel
		self.arragement = stopOverType.timeLabelArragament
		let time = stopOver.stopOverType.timeLabelViewTime(timeStringContainer: stopOver.timeContainer.stringTimeValue)
		self.time = Prognosed(actual: time.actual ?? "",planned: time.planned ?? "")
		self.isCancelled = stopOver.cancellationType() == .fullyCancelled
	}
	
	init(
		stopOver : StopViewData
	) {
		self.delay = stopOver.stopOverType.timeLabelViewDelay(timeContainer: stopOver.timeContainer)
		self.isSmall = stopOver.stopOverType.smallTimeLabel
		self.arragement = stopOver.stopOverType.timeLabelArragament
		let time = stopOver.stopOverType.timeLabelViewTime(timeStringContainer: stopOver.timeContainer.stringTimeValue)
		self.time = Prognosed(actual: time.actual ?? "",planned: time.planned ?? "")
		self.isCancelled = stopOver.cancellationType() == .fullyCancelled
	}
}
