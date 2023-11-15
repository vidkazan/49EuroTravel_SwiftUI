//
//  +sideEffect.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.09.23.
//

import Combine
import Foundation
import SwiftUI

extension ChewViewModel {
	static func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
		Feedback { _ in
			return input
		}
	}
	
	func whenIdleCheckForSufficientDataForJourneyRequest() -> Feedback<State, Event> {
		Feedback { (state: State) -> AnyPublisher<Event, Never> in
			guard case .idle = state.status else { return Empty().eraseToAnyPublisher() }
			
//			let test = ChewUser(context: self.viewContext)
//			test.date = state.timeChooserDate.date
//			test.isFirstAppEntry = false
			
//			do {
//				try self.viewContext.save()
//			} catch {
//				fatalError()
//			}
			guard state.depStop != nil && state.arrStop != nil else { return Empty().eraseToAnyPublisher() }
			return Just(Event.onJourneyDataUpdated)
				.eraseToAnyPublisher()
		}
	}
	
	func whenLoadingInitialData() -> Feedback<State, Event> {
		Feedback { (state: State) -> AnyPublisher<Event, Never> in
			guard case .loadingInitialData(viewContext: let context) = state.status else { return Empty().eraseToAnyPublisher() }
			guard let ts = Item.basicFetchRequest(context: context)?.timestamp else {
				return Just(Event.didLoadInitialData(.now))
					.eraseToAnyPublisher()
			}
			return Just(Event.didLoadInitialData(.specificDate(ts)))
				.eraseToAnyPublisher()
		}
	}
}

