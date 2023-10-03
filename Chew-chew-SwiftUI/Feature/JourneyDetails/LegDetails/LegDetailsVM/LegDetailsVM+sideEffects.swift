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
	func when() -> Feedback<State, Event> {
	  Feedback { (state: State) -> AnyPublisher<Event, Never> in
		  return Just(Event.didUpdateTime).eraseToAnyPublisher()
	  }
	}
}
