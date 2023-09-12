//
//  SearchJourneyVM+reduce+3.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//

import Foundation


extension JourneyListViewModel {
	func reduceLoadingUpdate(_ state:  State, _ event: Event) -> State {
		guard case .loadingRef = state.status else { return state }
		switch event {
		case .onNewJourneysData(let data, let type):
			let newData = constructJourneysViewData(journeysData: data,startId: state.journeys.count)
			switch type {
			case .initial:
				return state
			case .earlierRef:
				return State(
					journeys: newData + state.journeys,
					earlierRef: data.earlierRef,
					laterRef: data.laterRef,
					status: .journeysLoaded
				)
			case .laterRef:
				return State(
					journeys: state.journeys + newData,
					earlierRef: data.earlierRef,
					laterRef: data.laterRef,
					status: .journeysLoaded
				)
			}
		case .onFailedToLoadJourneysData(let err):
			return State(
				journeys: state.journeys,
				earlierRef: state.earlierRef,
				laterRef: state.laterRef,
				status: .failedToLoadJourneys(err)
			)
		default:
			return state
		}
	}
}
