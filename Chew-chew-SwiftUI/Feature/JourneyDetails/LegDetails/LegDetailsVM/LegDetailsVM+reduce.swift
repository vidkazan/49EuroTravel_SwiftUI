//
//  JourneyDetailsVM+reduce.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.09.23.
//

import Foundation



extension LegDetailsViewModel {
	static func reduce(_ state: State, _ event: Event) -> State {
		print("🦵🔥 > ",event.description,"state:",state.status.description, state.data.leg.lineViewData.name)
		switch state.status {
		case .idle:
			switch event {
			case .didtapExpandButton:
				return State(
					data: StateData(
						leg: state.data.leg,
						totalProgressHeight: state.data.leg.progressSegments.heightTotalExtended,
						currentProgressHeight: state.data.leg.progressSegments.evaluate(time: Date.now.timeIntervalSince1970,type: .expanded)
					),
					status: .stopovers
				)
			case .didDisappear:
				return State(data: state.data,status: .disappeared)
			}
		case .stopovers:
			switch event {
			case .didtapExpandButton:
				return State(
					data: StateData(
						leg: state.data.leg,
						totalProgressHeight: state.data.leg.progressSegments.heightTotalCollapsed,
						currentProgressHeight: state.data.leg.progressSegments.evaluate(time: Date.now.timeIntervalSince1970,type: .collapsed)
					),
					status: .idle
				)
			case .didDisappear:
				return State( data: state.data, status: .disappeared )
			}
		case .disappeared:
			return state
		}
	}
}
