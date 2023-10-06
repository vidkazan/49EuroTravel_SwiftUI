//
//  JourneyDetailsVM+reduce.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.09.23.
//

import Foundation

extension LegDetailsViewModel {
	func reduce(_ state: State, _ event: Event) -> State {
		print("🟣🔥 > leg details event:",event.description,"state:",state.status.description, state.leg.lineViewData.name)
		switch state.status {
		case .idle:
			switch event {
			case .didtapExpandButton:
				return State(
					status: .stopovers,
					leg: state.leg,
					currentHeight: state.leg.progressSegments.evaluate(time: Date.now.timeIntervalSince1970,type: .expanded),
					totalHeight: state.leg.progressSegments.heightTotalExtended
				)
			case .didUpdateTime:
				return State(
					status: state.status,
					leg: state.leg,
					currentHeight: state.leg.progressSegments.evaluate(time: Date.now.timeIntervalSince1970,type: .collapsed),
					totalHeight: state.leg.progressSegments.heightTotalCollapsed
				)
			case .didDisappear:
				return State(
					status: .disappeared,
					leg: state.leg,
					currentHeight: state.currentProgressHeight,
					totalHeight: state.totalProgressHeight
				)
			}
		case .stopovers:
			switch event {
			case .didtapExpandButton:
				return State(
					status: .idle,
					leg: state.leg,
					currentHeight: state.leg.progressSegments.evaluate(time: Date.now.timeIntervalSince1970,type: .collapsed),
					totalHeight: state.leg.progressSegments.heightTotalCollapsed
				)
			case .didUpdateTime:
				return State(
					status: state.status,
					leg: state.leg,
					currentHeight: state.leg.progressSegments.evaluate(time: Date.now.timeIntervalSince1970,type: .expanded),
					totalHeight: state.leg.progressSegments.heightTotalExtended
				)
			case .didDisappear:
				return State(
					status: .disappeared,
					leg: state.leg,
					currentHeight: state.currentProgressHeight,
					totalHeight: state.totalProgressHeight
				)
			}
		case .disappeared:
			return State(
				status: .disappeared,
				leg: state.leg,
				currentHeight: state.currentProgressHeight,
				totalHeight: state.totalProgressHeight
			)
		}
	}
}
