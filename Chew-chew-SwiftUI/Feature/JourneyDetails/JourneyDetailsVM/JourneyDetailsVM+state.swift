//
//  JourneyDetailsVM+state.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.09.23.
//

import Foundation
import MapKit

extension JourneyDetailsViewModel {
	enum BottomSheetType : Equatable,Hashable {
		case locationDetails
		case fullLeg
	}
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
		case loadedJourneyData
		case error(error : ApiServiceError)
		case loadingLocationDetails(leg : LegViewData)
		case locationDetails(coordRegion : MKCoordinateRegion, coordinates : [CLLocationCoordinate2D])
		case fullLeg(leg : LegViewData)
		case loadingFullLeg(leg : LegViewData)
		case actionSheet(leg : LegViewData)
		
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
			case .loadingLocationDetails:
				return "loadingLocationDetails"
			case .fullLeg:
				return "fullLeg"
			case .actionSheet:
				return "actionSheet"
			case .loadingFullLeg:
				return "loadingFullLeg"
			}
		}
	}
	
	enum Event {
		case didLoadJourneyData(data : JourneyViewData)
		case didFailedToLoadJourneyData(error : ApiServiceError)
		case didTapReloadJourneys
		case didExpandLegDetails
		case didLoadLocationDetails(coordRegion : MKCoordinateRegion, coordinates : [CLLocationCoordinate2D])
		case didLoadFullLegData(data : LegViewData)
		case didLongTapOnLeg(leg : LegViewData)
		case didCloseActionSheet
		
		case didTapBottomSheetDetails(leg : LegViewData, type : BottomSheetType)
		case didCloseBottomSheet
		
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
			case .didLoadLocationDetails:
				return "didLoadLocationDetails"
			case .didLongTapOnLeg:
				return "didLongTapOnLeg"
			case .didCloseActionSheet:
				return "didCloseActionSheet"
			case .didTapBottomSheetDetails:
				return "didCloseActionSheet"
			case .didCloseBottomSheet:
				return "didCloseBottomSheet"
			case .didLoadFullLegData:
				return "didLoadFullLegData"
			}
		}
	}
}

