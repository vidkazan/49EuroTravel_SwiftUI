//
//  SearchJourneyVM+state.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 06.09.23.
//

import Foundation

extension JourneyListViewModel {
	
	struct State : Equatable {
		var journeys :  [JourneyViewData]
		var earlierRef : String?
		var laterRef : String?
		var status : Status
		
		init(journeys: [JourneyViewData], earlierRef: String?, laterRef: String?, status: Status) {
			self.journeys = journeys
			self.earlierRef = earlierRef
			self.laterRef = laterRef
			self.status = status
		}
	}
	
	enum JourneyUpdateType {
		case initial
		case earlierRef
		case laterRef
	}
	
	enum Status : Equatable {
		static func == (lhs: JourneyListViewModel.Status, rhs: JourneyListViewModel.Status) -> Bool {
			return lhs.description == rhs.description
		}
		
		case loadingRef(JourneyUpdateType)
		case loadingJourneys
		case journeysLoaded
		case failedToLoadJourneys(ApiServiceError)
		
		var description : String {
			switch self {
			case .loadingJourneys:
				return "loadingJourneys"
			case .failedToLoadJourneys:
				return "failedToLoadJourneys"
			case .journeysLoaded:
				return "journeysLoaded"
			case .loadingRef:
				return "loadingRef"
			}
		}
	}
	
	enum Event {
		case onNewJourneysData(JourneysContainer,JourneyUpdateType)
		case onFailedToLoadJourneysData(ApiServiceError)
		case onReloadJourneys
		case onLaterRef
		case onEarlierRef
		
		var description : String {
			switch self {
			case .onNewJourneysData:
				return "onNewJourneysData"
			case .onFailedToLoadJourneysData:
				return "onFailedToLoadJourneysData"
			case .onReloadJourneys:
				return "onReloadJourneys"
			case .onLaterRef:
				return "onLaterRef"
			case .onEarlierRef:
				return "onEarlierRef"
			}
		}
	}
}
