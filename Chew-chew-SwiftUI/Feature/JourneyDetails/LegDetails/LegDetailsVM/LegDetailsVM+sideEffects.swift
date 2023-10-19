//
//  JourneyDetailsVM+sideEffect.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.09.23.
//

import Foundation
import Combine

extension LegDetailsViewModel {
	
	static func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
		Feedback { _ in
			return input
		}
	}
	static func updateByTimer() -> Feedback<State, Event> {
		Feedback { (state: State) -> AnyPublisher<Event, Never> in
			switch state.status {
			case .idle,.stopovers:
				let now = Date.now.timeIntervalSince1970
				guard
					let first : Double = state.leg.progressSegments.segments.first?.time,
					let last : Double = state.leg.progressSegments.segments.last?.time,
					now - last < 0 else {
					return Empty().eraseToAnyPublisher()
				}
				let delayFirst : Double = first - now
				return Just(Event.didUpdateTime)
					.delay(
						for: delayFirst > 0 ? .seconds(delayFirst) :  .seconds(10),
						scheduler: DispatchQueue.main
					)
					.eraseToAnyPublisher()
			case .disappeared:
				return Empty().eraseToAnyPublisher()
			}
		}
	}
}
