//
//  SearchLocationVM+reduce+Loaded.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//

import Foundation

extension SearchLocationViewModel {
	static func reduceLoaded(_ state:  State, _ event: Event) -> State {
		guard case .loaded = state.status else { return state }
		switch event {
		case .onSearchFieldDidChanged(let string, let type):
			return State(
				stops: state.stops,
				previousSearchLineString: state.previousSearchLineString,
				status: .loading(string, type),
				type: state.type
			)
		case .onDataLoaded, .onDataLoadError:
			return state
		case .onStopDidTap((_), let type):
			return State(
				stops: [],
				previousSearchLineString: "",
				status: .idle,
				type: state.type
			)
		case .onReset(_):
			return State(
				stops: [],
				previousSearchLineString: "",
				status: .idle,
				type: state.type
			)
		}
	}
}
