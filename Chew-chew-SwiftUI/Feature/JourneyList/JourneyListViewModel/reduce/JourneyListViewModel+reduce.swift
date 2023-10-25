//
//  SearchJourneyVM+reduce.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 06.09.23.
//

import Foundation

extension JourneyListViewModel {
	func reduce(_ state: State, _ event: Event) -> State {
		print("🟤🔥 >> journeys event:",event.description)
		switch state.status {
		case .loadingJourneys:
			return reduceLoadingJourneys(state, event)
		case .journeysLoaded:
			return reduceJourneysLoaded(state, event)
		case .failedToLoadJourneys:
			return reduceFailedToLoadJourneys(state, event)
		case .loadingRef:
			return reduceLoadingUpdate(state, event)
		case .failedToLoadLaterRef, .failedToLoadEarlierRef:
			switch event {
			case .onNewJourneysData:
				return state
			case .onFailedToLoadJourneysData:
				return state
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
			case .didFailToLoadLaterRef, .didFailToLoadEarlierRef:
				return state
			}
		}
	}
}
