//
//  SearchJourneyVM+reduce+.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//

import Foundation


extension JourneyListViewModel {
	func reduceFailedToLoadJourneys(_ state:  State, _ event: Event) -> State {
		guard case .failedToLoadJourneys = state.status else { return state }
			return state
	}
}

