//
//  SearchLocationVM+reduce.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 06.09.23.
//

import Foundation

extension SearchLocationViewModel {
	func reduce(_ state:  State, _ event: Event) -> State {
		print("🔵🔥 >> stops event:",event.description,"state:",state.status.description)
		
		switch state.status {
		case .idle:
			return SearchLocationViewModel.reduceIdle(state, event)
		case .loading:
			return SearchLocationViewModel.reduceLoading(state, event)
		case .loaded:
			return SearchLocationViewModel.reduceLoaded(state, event)
		case .error:
			return SearchLocationViewModel.reduceError(state, event)
//		case .loadingLocation:
//			return SearchLocationViewModel.reduceLoadingLocation(state, event)
//		case .loadedUserLocation:
//			return SearchLocationViewModel.reduceLoadedUserLocationData(state, event)
		}
	}
}
