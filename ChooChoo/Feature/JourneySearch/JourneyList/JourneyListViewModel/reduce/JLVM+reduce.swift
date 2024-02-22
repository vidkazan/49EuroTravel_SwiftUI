//
//  SearchJourneyVM+reduce.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 06.09.23.
//

import Foundation

extension JourneyListViewModel {
	static func reduce(_ state: State, _ event: Event) -> State {
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
			case .didFailToLoadLaterRef, .didFailToLoadEarlierRef,.onNewJourneyListData,.onFailedToLoadJourneyListData:
				print("⚠️ \(Self.self): reduce error: \(state.status) \(event.description)")
				return state
			}
		}
	}
}
