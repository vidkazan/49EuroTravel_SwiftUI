//
//  SearchJourneyVM+reduce.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 06.09.23.
//

import Foundation

extension JourneyListViewModel {
	func reduce(_ state: State, _ event: Event) -> State {
		print("[🚂]🔥 > ",event.description)
		switch state.status {
		case .loadingJourneyList:
			return reduceLoadingJourneyList(state, event)
		case .journeysLoaded:
			return reduceJourneyListLoaded(state, event)
		case .failedToLoadJourneyList:
			return reduceFailedToLoadJourneyList(state, event)
		case .loadingRef:
			return reduceLoadingUpdate(state, event)
		case .failedToLoadLaterRef, .failedToLoadEarlierRef:
			switch event {
			case .onNewJourneyListData:
				return state
			case .onFailedToLoadJourneyListData:
				return state
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
			case .didFailToLoadLaterRef, .didFailToLoadEarlierRef:
				return state
			}
		}
	}
}
