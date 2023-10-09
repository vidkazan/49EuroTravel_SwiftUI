//
//  JourneyDetailsVM+state.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.09.23.
//

import Foundation
import MapKit

extension JourneyDetailsViewModel {
	struct State : Equatable {
		let data : JourneyViewData
		let status : Status
		init(data: JourneyViewData, status: Status) {
			self.data = data
			self.status = status
		}
	}
	
	enum Status : Equatable {
		static func == (lhs: JourneyDetailsViewModel.Status, rhs: JourneyDetailsViewModel.Status) -> Bool {
			return lhs.description == rhs.description
		}
		case loading(refreshToken : String?)
		case loadedJourneyData(data : JourneyViewData)
		case error(error : ApiServiceError)
		case locationDetails(coordRegion : MKCoordinateRegion, coordinates : [CLLocationCoordinate2D])
		
		var description : String {
			switch self {
			case .loading:
				return "loading"
			case .loadedJourneyData:
				return "loadedJourneyData"
			case .error:
				return "error"
			case .locationDetails:
				return "locationDetails"
			}
		}
	}
	
	enum Event {
		case didLoadJourneyData(data : JourneyViewData)
		case didFailedToLoadJourneyData(error : ApiServiceError)
		case didTapReloadJourneys
		case didExpandLegDetails
		case didTapLocationDetails(coordRegion : MKCoordinateRegion, coordinates : [CLLocationCoordinate2D])
		case didCloseLocationDetails
		
		var description : String {
			switch self {
			case .didLoadJourneyData:
				return "didLoadJourneyData"
			case .didFailedToLoadJourneyData:
				return "didFailedToLoadJourneyData"
			case .didTapReloadJourneys:
				return "didReloadJourneys"
			case .didExpandLegDetails:
				return "didExpandLegDetails"
			case .didTapLocationDetails:
				return "didTapLocationDetails"
			case .didCloseLocationDetails:
				return "didCloseLocationDetails"
			}
		}
	}
}
 
