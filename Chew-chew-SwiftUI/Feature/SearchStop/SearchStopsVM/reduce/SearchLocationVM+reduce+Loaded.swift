//
//  SearchLocationVM+reduce+Loaded.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//

import Foundation

extension SearchStopsViewModel {
	static func reduceLoaded(_ state:  State, _ event: Event) -> State {
		guard case .loaded = state.status else { return state }
		switch event {
		case .onSearchFieldDidChanged(let string, let type):
			return State(
				previousStops: state.previousStops,
				stops: state.stops,
				status: .loading(string),
				type: type
			)
		case .onDataLoaded,.onDataLoadError,.didRecentStopsUpdated:
			return state
		case .onStopDidTap(let stop,_):
			return State(
				previousStops: state.previousStops,
				stops: [],
				status: .updatingRecentStops(stop),
				type: nil
			)
		case .onReset(let type):
			return State(
				previousStops: state.previousStops,
				stops: [],
				status: .idle,
				type: type
			)
		}
	}
}
