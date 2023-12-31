//
//  SearchLocationVM+reduce+Loading.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//

import Foundation


extension SearchLocationViewModel {
	static func reduceLoadingLocation(_ state:  State, _ event: Event) -> State {
		guard case .loadingLocation = state.status else { return state }
		switch event {
		case .onSearchFieldDidChanged(let string, let type):
			return State(
				stops: state.stops,
				previousSearchLineString: state.previousSearchLineString,
				status: .loading(string, type),
				type: type
			)
		case .onReset:
			return State(
				stops: [],
				previousSearchLineString: "",
				status: .idle,
				type: state.type
			)
		case .onStopDidTap,.onDataLoaded,.onDataLoadError:
			return state
		}
	}
}
