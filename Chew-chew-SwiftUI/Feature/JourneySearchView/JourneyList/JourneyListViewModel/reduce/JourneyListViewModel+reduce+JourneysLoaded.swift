//
//  SearchJourneyVM+reduce+4.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//

import Foundation

extension JourneyListViewModel {
	static func reduceJourneyListLoaded(_ state:  State, _ event: Event) -> State {
		guard case .journeysLoaded = state.status else { return state }
		switch event {
		case .onReloadJourneyList:
			return State(
				data: state.data,
				status: .loadingJourneyList
			)
		case .onLaterRef:
			return State(
				data: state.data,
				status: .loadingRef(.laterRef)
			)
		case .onEarlierRef:
			return State(
				data: state.data,
				status: .loadingRef(.earlierRef)
			)
		case .onNewJourneyListData(_, _):
			print("⚠️ \(Self.self): reduce error: \(state.status) \(event.description)")
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

