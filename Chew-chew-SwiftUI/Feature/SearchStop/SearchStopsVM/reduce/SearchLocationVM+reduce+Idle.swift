//
//  SearchLocationVM+reduce+Idle.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//

import Foundation

extension SearchStopsViewModel {
	static func reduceIdle(_ state:  State, _ event: Event) -> State {
		guard case .idle = state.status else { return state }
		switch event {
		case .onSearchFieldDidChanged(let string, let type):
			return State(
				previousStops: state.previousStops,
				stops: state.stops,
				status: .loading(string),
				type: type
			)
		case .onReset(let type):
			return State(
				previousStops: state.previousStops,
				stops: state.stops,
				status: .idle,
				type: type
			)
		case
				.onDataLoaded,
				.didRecentStopsUpdated,
				.onDataLoadError,
				.onStopDidTap:
			return state
		}
	}
}


