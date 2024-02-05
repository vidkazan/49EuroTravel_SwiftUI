//
//  JourneyDetailsVM+reduce.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.09.23.
//

import Foundation


//
//extension LegDetailsViewModel {
//	static func reduce(_ state: State, _ event: Event) -> State {
//		print("🦵🔥 > ",event.description,"state:",state.status.description, state.data.leg.lineViewData.name)
//		switch state.status {
//		case .idle:
//			switch event {
//			case .didTapExpandButton(refTimeTS: let ts):
//				return State(
//					data: StateData(
//						leg: state.data.leg,
//						totalProgressHeight: state.data.leg.progressSegments.heightTotalExtended,
//						currentProgressHeight: state.data.leg.progressSegments.evaluate(time: ts,type: .expanded)
//					),
//					status: .stopovers
//				)
//			}
//		case .stopovers:
//			switch event {
//			case .didTapExpandButton(refTimeTS: let ts):
//				return State(
//					data: StateData(
//						leg: state.data.leg,
//						totalProgressHeight: state.data.leg.progressSegments.heightTotalCollapsed,
//						currentProgressHeight: state.data.leg.progressSegments.evaluate(time: ts,type: .collapsed)
//					),
//					status: .idle
//				)
//			}
//		}
//	}
//}
