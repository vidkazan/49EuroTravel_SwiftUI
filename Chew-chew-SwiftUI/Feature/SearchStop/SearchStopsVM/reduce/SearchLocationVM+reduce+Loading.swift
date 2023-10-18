//
//  SearchLocationVM+reduce+Loading.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//

import Foundation


extension SearchStopsViewModel {
	static func reduceLoading(_ state:  State, _ event: Event) -> State {
		guard case .loading = state.status else { return state }
		switch event {
		case .onDataLoaded(let stops, let type):
			return State(
				stops: stops,
				status: .loaded,
				type: type
			)
		case .onDataLoadError(let error):
			return State(
				stops: [],
				status: .error(error),
				type: state.type
			)
		case .onSearchFieldDidChanged(let string, let type):
			return State(
				stops: state.stops,
				status: .loading(string),
				type: type
			)
		case .onReset(let type):
			return State(
				stops: [],
				status: .idle,
				type: type
			)
		case .onStopDidTap:
			return State(
				stops: [],
				status: .idle,
				type: nil
			)
		}
	}
}
