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
		case loadingJourneyList
		case journeysLoaded
		case failedToLoadLaterRef(ApiServiceError)
		case failedToLoadEarlierRef(ApiServiceError)
		case failedToLoadJourneyList(ApiServiceError)
		
		var description : String {
			switch self {
			case .loadingJourneyList:
				return "loadingJourneyList"
			case .failedToLoadJourneyList:
				return "failedToLoadJourneyList"
			case .journeysLoaded:
				return "journeysLoaded"
			case .loadingRef:
				return "loadingRef"
			case .failedToLoadLaterRef:
				return "didFailedToLoadLaterRef"
			case .failedToLoadEarlierRef:
				return "didFailedToLoadEarlierRef"
			}
		}
	}
	
	enum Event {
		case onNewJourneyListData(JourneyListViewData,JourneyUpdateType)
		case onFailedToLoadJourneyListData(ApiServiceError)
		case onReloadJourneyList
		case onLaterRef
		case onEarlierRef
		case didFailToLoadLaterRef(ApiServiceError)
		case didFailToLoadEarlierRef(ApiServiceError)
		var description : String {
			switch self {
			case .onNewJourneyListData:
				return "onNewJourneyListData"
			case .onFailedToLoadJourneyListData:
				return "onFailedToLoadJourneyListData"
			case .onReloadJourneyList:
				return "onReloadJourneyList"
			case .onLaterRef:
				return "onLaterRef"
			case .onEarlierRef:
				return "onEarlierRef"
			case .didFailToLoadLaterRef:
				return "didFailToLoadLaterRef"
			case .didFailToLoadEarlierRef:
				return "didFailToLoadEarlierRef"
			}
		}
	}
}
