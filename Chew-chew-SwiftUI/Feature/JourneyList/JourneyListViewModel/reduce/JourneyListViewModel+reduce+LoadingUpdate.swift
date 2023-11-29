//
//  SearchJourneyVM+reduce+3.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//

import Foundation


extension JourneyListViewModel {
	func reduceLoadingUpdate(_ state:  State, _ event: Event) -> State {
		guard case .loadingRef = state.status else { return state }
		switch event {
		case .onNewJourneyListData(let data, let type):
			switch type {
			case .initial:
				return state
			case .earlierRef:
				return State(
					journeys: data.journeys + state.journeys,
					earlierRef: data.earlierRef,
					laterRef: data.laterRef,
					status: .journeysLoaded
				)
			case .laterRef:
				return State(
					journeys: state.journeys + data.journeys,
					earlierRef: data.earlierRef,
					laterRef: data.laterRef,
					status: .journeysLoaded
				)
			}
		case .onFailedToLoadJourneyListData(let err):
			return State(
				journeys: state.journeys,
				earlierRef: state.earlierRef,
				laterRef: state.laterRef,
				status: .failedToLoadJourneyList(err)
			)
		case .onReloadJourneyList:
			return state
		case .onLaterRef:
			return state
		case .onEarlierRef:
			return state
		case .didFailToLoadLaterRef(let error):
			return State(
				journeys: state.journeys,
				earlierRef: state.earlierRef,
				laterRef: state.laterRef,
				status: .failedToLoadLaterRef(error)
			)
		case .didFailToLoadEarlierRef(let error):
			return State(
				journeys: state.journeys,
				earlierRef: state.earlierRef,
				laterRef: state.laterRef,
				status: .failedToLoadEarlierRef(error)
			)
		}
	}
}
