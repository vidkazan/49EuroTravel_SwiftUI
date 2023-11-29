//
//  SearchJourneyVM+reduce+4.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//

import Foundation

extension JourneyListViewModel {
	func reduceJourneyListLoaded(_ state:  State, _ event: Event) -> State {
		guard case .journeysLoaded = state.status else { return state }
		switch event {
		case .onReloadJourneyList:
			return State(
				journeys: state.journeys,
				earlierRef: state.earlierRef,
				laterRef: state.laterRef,
				status: .loadingJourneyList
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
		case .onNewJourneyListData(_, _):
			return state
		case .onFailedToLoadJourneyListData(_):
			return state
		case .didFailToLoadLaterRef(_):
			return state
		case .didFailToLoadEarlierRef(_):
			return state
		}
	}
}

