//
//  SearchJourneyVM+reduce+3.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//

import Foundation


extension JourneyListViewModel {
	func reduceLoadingJourneys(_ state:  State, _ event: Event) -> State {
		guard case .loadingJourneys = state.status else { return state }
		switch event {
		case .onNewJourneysData(let data, let type):
			switch type {
			case .initial:
				return State(
					journeys: constructJourneysViewData(journeysData: data),
					earlierRef: data.earlierRef,
					laterRef: data.laterRef,
					status: .journeysLoaded
				)
			default:
				return .init(journeys: [], earlierRef: nil, laterRef: nil, status: .failedToLoadJourneys)
			}
		case .onFailedToLoadJourneysData:
			return State(
				journeys: [],
				earlierRef: nil,
				laterRef: nil,
				status: .failedToLoadJourneys
			)
		default:
			return state
		}
	}
}
