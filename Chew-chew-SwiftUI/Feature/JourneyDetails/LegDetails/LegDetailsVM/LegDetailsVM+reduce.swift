//
//  JourneyDetailsVM+reduce.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.09.23.
//

import Foundation

extension LegDetailsViewModel {
	func reduce(_ state: State, _ event: Event) -> State {
		print("🟣🔥 > details event:",event.description,"state:",state.status.description)
		switch state.status {
		case .idle:
			switch event {
			case .didtapExpandButton:
				return State(
					status: .stopovers,
					leg: state.leg,
					currentHeight: state.leg.progressSegments.evaluateExpanded(time: Date.now.timeIntervalSince1970),
					totalHeight: state.leg.heights.totalHeightWithStopovers
				)
			case .didUpdateTime:
				return State(
					status: state.status,
					leg: state.leg,
					currentHeight: state.leg.progressSegments.evaluateCollapsed(time: Date.now.timeIntervalSince1970),
					totalHeight: state.leg.heights.totalHeight
				)
			}
		case .stopovers:
			switch event {
			case .didtapExpandButton:
				return State(
					status: .idle,
					leg: state.leg,
					currentHeight: state.leg.progressSegments.evaluateCollapsed(time: Date.now.timeIntervalSince1970),
					totalHeight: state.leg.heights.totalHeight
				)
			case .didUpdateTime:
				return State(
					status: state.status,
					leg: state.leg,
					currentHeight: state.leg.progressSegments.evaluateExpanded(time: Date.now.timeIntervalSince1970),
					totalHeight: state.leg.heights.totalHeightWithStopovers
				)
			}
		}
	}
}
