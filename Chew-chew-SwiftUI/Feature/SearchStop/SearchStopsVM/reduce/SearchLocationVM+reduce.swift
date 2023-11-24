//
//  SearchLocationVM+reduce.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 06.09.23.
//

import Foundation

extension SearchStopsViewModel {
	func reduce(_ state:  State, _ event: Event) -> State {
		print("🔵🔥 >> stops event:",event.description,"state:",state.status.description)
		switch state.status {
		case .updatingRecentStops:
			switch event {
			case .onSearchFieldDidChanged:
				return state
			case .onDataLoaded:
				return state
			case .onDataLoadError:
				return state
			case .onReset:
				return state
			case .onStopDidTap:
				return state
			case .didRecentStopsUpdated(let recentStops):
				return State(
					previousStops: recentStops,
					stops: [],
					status: .idle
				)
			case .didChangeFieldFocus(type: let type):
				return State(
					previousStops: state.previousStops,
					stops: state.stops,
					status: state.status,
					type: type
				)
			}
		case .idle:
			return SearchStopsViewModel.reduceIdle(state, event)
		case .loading:
			return SearchStopsViewModel.reduceLoading(state, event)
		case .loaded:
			return SearchStopsViewModel.reduceLoaded(state, event)
		case .error:
			return SearchStopsViewModel.reduceError(state, event)
		}
	}
}
