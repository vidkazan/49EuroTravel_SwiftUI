//
//  SearchLocationVM+reduce+Loading.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//

import Foundation


//extension SearchLocationViewModel {
//	static func reduceLoadingLocation(_ state:  State, _ event: Event) -> State {
//		guard case .loadingLocation = state.status else { return state }
//		switch event {
//		case .onSearchFieldDidChanged(let string, let type):
//			return State(
//				stops: state.stops,
//				previousSearchLineString: state.previousSearchLineString,
//				status: .loading(string, type),
//				type: type
//			)
//		case .onReset:
////			return State(
////				stops: [],
////				previousSearchLineString: "",
////				status: .idle,
////				type: state.type
////			)
//			return state
//		case .onStopDidTap,.onDataLoaded,.onDataLoadError,.didSetUserLocationData:
//			return state
//		case .didReceiveLocaitonData(lat: let lat, long: let long):
//			return State(
//				stops: [],
//				previousSearchLineString: "",
//				status: .loadedUserLocation(lat: lat, long: long),
//				type: .departure
//			)
//		case .didFailToLoadLocationData:
//			return State(
//				stops: [],
//				previousSearchLineString: "",
//				status: .error(.failedToGetUserLocation),
//				type: .departure
//			)
//		case .didLocationButtonPressed:
////			return State(
////				stops: [],
////				previousSearchLineString: "",
////				status: .loadingLocation,
////				type: .departure
////			)
//			return state
//		}
//	}
//}
