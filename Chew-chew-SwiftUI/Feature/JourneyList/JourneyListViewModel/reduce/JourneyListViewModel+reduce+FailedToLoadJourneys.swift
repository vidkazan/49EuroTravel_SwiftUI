//
//  SearchJourneyVM+reduce+.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//

import Foundation


extension JourneyListViewModel {
	func reduceFailedToLoadJourneyList(_ state:  State, _ event: Event) -> State {
		guard case .failedToLoadJourneyList = state.status else { return state }
		switch event {
		case .onReloadJourneyList:
			return State(
				journeys: state.journeys,
				earlierRef: state.earlierRef,
				laterRef: state.laterRef,
				status: .loadingJourneyList
			)
		default:
			print("⚠️ \(Self.self): reduce error: \(state.status) \(event.description)")
			return state
		}
	}
}

