//
//  SearchLocationVM+reduce+Idle.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//

import Foundation

extension SearchLocationViewModel {
	static func reduceIdle(_ state:  State, _ event: Event) -> State {
		guard case .idle = state.status else { return state }
		switch event {
		case .onSearchFieldDidChanged(let string, let type):
			return State(
				stops: state.stops,
				previousSearchLineString: state.previousSearchLineString,
				status: .loading(string, type),
				type: state.type
			)
		case
			.onDataLoaded,
			.onDataLoadError,
			.onReset,
			.onStopDidTap:
//			.didReceiveLocaitonData,
//			.didFailToLoadLocationData,
//			.didSetUserLocationData:
			return state
			
//		case .didLocationButtonPressed:
//			return State(
//				stops: [],
//				previousSearchLineString: "",
//				status: .loadingLocation,
//				type: .departure
//			)
		}
	}
}


