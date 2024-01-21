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
		case .didChangeFieldFocus(type: let type):
			return State(
				previousStops: state.previousStops,
				stops: state.stops,
				status: state.status,
				type: type
			)
		case .onSearchFieldDidChanged(let string, let type):
			return State(
				previousStops: state.previousStops,
				stops: state.stops,
				status: .loading(string),
				type: type
			)
		case .onDataLoaded,.onDataLoadError,.didRecentStopsUpdated:
			print("⚠️ \(Self.self): reduce error: \(state.status) \(event.description)")
			return state
		case .onStopDidTap(let content,_):
			return State(
				previousStops: state.previousStops,
				stops: [],
				status: .updatingRecentStops(content.stop),
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
