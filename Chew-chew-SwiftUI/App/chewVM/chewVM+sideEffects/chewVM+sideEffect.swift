//
//  +sideEffect.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.09.23.
//

import Combine
import Foundation

extension ChewViewModel {
	static func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
		Feedback { _ in
			return input
		}
	}
	
	func whenIdleCheckForSufficientDataForJourneyRequest() -> Feedback<State, Event> {
		Feedback { (state: State) -> AnyPublisher<Event, Never> in
			guard case .idle = state.status else { return Empty().eraseToAnyPublisher() }
			guard state.depStop != nil && state.arrStop != nil else { return Empty().eraseToAnyPublisher() }
			return Just(Event.onJourneyDataUpdated)
				.eraseToAnyPublisher()
		}
	}
}

