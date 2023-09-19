//
//  JourneyDetailsVM+state.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.09.23.
//

import Foundation

extension JourneyDetailsViewModel {
	struct State : Equatable {
		let data : JourneyCollectionViewDataSourse
		let status : Status
		init(data: JourneyCollectionViewDataSourse, status: Status) {
			self.data = data
			self.status = status
		}
	}
	
	enum Status : Equatable {
		static func == (lhs: JourneyDetailsViewModel.Status, rhs: JourneyDetailsViewModel.Status) -> Bool {
			return lhs.description == rhs.description
		}
		case loading(refreshToken : String?)
		case loadedJourneyData(data : Journey)
		case error(error : ApiServiceError)
		
		var description : String {
			switch self {
			case .loading:
				return "loading"
			case .loadedJourneyData:
				return "loadedJourneyData"
			case .error:
				return "error"
			}
		}
	}
	
	enum Event {
		case didLoadJourneyData(data : Journey)
		case didFailedToLoadJourneyData(error : ApiServiceError)
		case didReloadJourneys
		
		var description : String {
			switch self {
			case .didLoadJourneyData:
				return "didLoadJourneyData"
			case .didFailedToLoadJourneyData:
				return "didFailedToLoadJourneyData"
			case .didReloadJourneys:
				return "didReloadJourneys"
			}
		}
	}
}
 
