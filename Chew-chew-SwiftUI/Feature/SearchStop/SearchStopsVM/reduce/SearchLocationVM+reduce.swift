//
//  SearchLocationVM+reduce.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 06.09.23.
//

import Foundation

extension SearchStopsViewModel {
	func reduce(_ state:  State, _ event: Event) -> State {
		print("🔵🔥 >> stops event:",event.description,"state:",state.status.description)
		
		switch state.status {
		case .idle:
			return SearchStopsViewModel.reduceIdle(state, event)
		case .loading:
			return SearchStopsViewModel.reduceLoading(state, event)
		case .loaded:
			return SearchStopsViewModel.reduceLoaded(state, event)
		case .error:
			return SearchStopsViewModel.reduceError(state, event)
		}
	}
}
