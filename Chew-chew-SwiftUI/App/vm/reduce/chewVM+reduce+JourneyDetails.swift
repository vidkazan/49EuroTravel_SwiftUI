//
//  ChewVM+reduce+Idle.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//

import Foundation

extension ChewViewModel {
	func reduceJourneyDetails(_ state:  State, _ event: Event) -> State {
		guard case .journeyDetails = state.status else { return state }
		switch event {
		default:
			return state
		}
	}
}

