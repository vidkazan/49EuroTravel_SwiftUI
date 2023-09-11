//
//  JourneyDetailsVM+reduce.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.09.23.
//

import Foundation

extension JourneyDetailsViewModel {
	func reduce(_ state: State, _ event: Event) -> State {
		switch state.status {
		case .idle:
			return state
		}
	}
}
