//
//  SearchJourneyVM+state.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 06.09.23.
//

import Foundation

protocol ChewViewModelProtocol : Identifiable {
	associatedtype ChewState
	var state : ChewState { get }
}

protocol ChewState : Equatable {
	associatedtype StateData : Equatable
	associatedtype Status : Equatable
	var data : StateData { get }
	var status : Status { get }
}

extension JourneyListViewModel {
	enum Error : ChewError {
		static func == (lhs: Error, rhs: Error) -> Bool {
			return lhs.description == rhs.description
		}
		
		func hash(into hasher: inout Hasher) {
			switch self {
			case .inputValIsNil:
				break
			}
		}
		case inputValIsNil(_ msg: String)
		
		
		var description : String  {
			switch self {
			case .inputValIsNil(let msg):
				return "Input value is nil: \(msg)"
			}
		}
	}

	struct StateData {
		var date : ChewViewModel.ChewDate
		var stops : DepartureArrivalPair
		var settings : ChewSettings
		var journeys :  [JourneyViewData]
		var earlierRef : String?
		var laterRef : String?
		
		init(stops: DepartureArrivalPair,date : ChewViewModel.ChewDate, settings: ChewSettings, journeys: [JourneyViewData], earlierRef: String?, laterRef: String?) {
			self.stops = stops
			self.date = date
			self.settings = settings
			self.journeys = journeys
			self.earlierRef = earlierRef
			self.laterRef = laterRef
		}
	}
	
	struct State {
		var data : StateData
		var status : Status
		
		init(data : StateData,status: Status){
			self.data = data
			self.status = status
		}
		init(journeys: [JourneyViewData],date : ChewViewModel.ChewDate, earlierRef: String?, laterRef: String?, settings : ChewSettings,stops : DepartureArrivalPair, status: Status) {
			self.data = StateData(
				stops: stops,
				date: date,
				settings: settings,
				journeys: journeys,
				earlierRef: earlierRef,
				laterRef: laterRef
			)
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
		case failedToLoadLaterRef(any ChewError)
		case failedToLoadEarlierRef(any ChewError)
		case failedToLoadJourneyList(any ChewError)
		
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
		case onFailedToLoadJourneyListData(any ChewError)
		case onReloadJourneyList
		case onLaterRef
		case onEarlierRef
		case didFailToLoadLaterRef(any ChewError)
		case didFailToLoadEarlierRef(any ChewError)
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
