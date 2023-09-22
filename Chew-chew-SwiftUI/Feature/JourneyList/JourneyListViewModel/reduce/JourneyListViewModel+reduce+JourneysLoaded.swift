//
//  SearchJourneyVM+reduce+4.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//

import Foundation

extension JourneyListViewModel {
	func reduceJourneysLoaded(_ state:  State, _ event: Event) -> State {
		guard case .journeysLoaded = state.status else { return state }
		switch event {
		case .onReloadJourneys:
			return State(
				journeys: state.journeys,
				earlierRef: state.earlierRef,
				laterRef: state.laterRef,
				status: .loadingJourneys
			)
		case .onLaterRef:
			return State(
				journeys: state.journeys,
				earlierRef: state.earlierRef,
				laterRef: state.laterRef,
				status: .loadingRef(.laterRef)
			)
		case .onEarlierRef:
			return State(
				journeys: state.journeys,
				earlierRef: state.earlierRef,
				laterRef: state.laterRef,
				status: .loadingRef(.earlierRef)
			)
		default:
			return state
		}
	}
}

