//
//  SearchLocationVM+reduce+Loading.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//

import Foundation


extension SearchLocationViewModel {
	static func reduceLoading(_ state:  State, _ event: Event) -> State {
		guard case .loading = state.status else { return state }
		switch event {
		case .onDataLoaded(let stops, let type):
			return State(
				stops: stops,
				previousSearchLineString: state.previousSearchLineString,
				status: .loaded,
				type: type
			)
		case .onDataLoadError(let error):
			return State(
				stops: [],
				previousSearchLineString: state.previousSearchLineString,
				status: .error(error),
				type: state.type
			)
		case .onSearchFieldDidChanged(let string, let type):
			return State(
				stops: state.stops,
				previousSearchLineString: state.previousSearchLineString,
				status: .loading(string, type),
				type: type
			)
		case .onReset(_):
			return State(
				stops: [],
				previousSearchLineString: "",
				status: .idle,
				type: state.type
			)
		case .onStopDidTap((_), let type):
			return State(
				stops: [],
				previousSearchLineString: "",
				status: .idle,
				type: type
			)
//		case .didReceiveLocaitonData, .didFailToLoadLocationData, .didSetUserLocationData,.didLocationButtonPressed:
//			return state
		}
	}
}
