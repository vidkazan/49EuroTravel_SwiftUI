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
		let isFollowed : Bool
		
		init(data: JourneyViewData, status: Status, followList : [String]) {
			self.data = data
			self.status = status
			self.isFollowed = followList.contains(where: {elem in elem == data.refreshToken})
		}
		init(data: JourneyViewData, status: Status, isFollowed : Bool) {
			self.data = data
			self.status = status
			self.isFollowed = isFollowed
		}
	}
	
	enum Status : Equatable {
		static func == (lhs: JourneyDetailsViewModel.Status, rhs: JourneyDetailsViewModel.Status) -> Bool {
			return lhs.description == rhs.description
		}
		case loading(token : String?)
		case loadingIfNeeded(token : String?)
		case loadedJourneyData
		case error(error : ApiServiceError)
		case loadingLocationDetails(leg : LegViewData)
		case locationDetails(
			coordRegion : MKCoordinateRegion,
			stops : [StopViewData],
			route : MKPolyline?
		)
		case fullLeg(leg : LegViewData)
		case loadingFullLeg(leg : LegViewData)
		case actionSheet(leg : LegViewData)
		
		case changingSubscribingState
		
		var description : String {
			switch self {
			case .changingSubscribingState:
				return "changingSubscribingState"
			case .loadingIfNeeded:
				return "loadingIfNeeded"
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
		
		
		case didRequestReloadIfNeeded
		case didTapReloadButton
		case didTapSubscribingButton
		
		case didExpandLegDetails
		case didLoadLocationDetails(
			coordRegion : MKCoordinateRegion,
			stops : [StopViewData],
			route : MKPolyline?
		)
		
		case didChangedSubscribingState(isFollowed : Bool)
		case didLoadFullLegData(data : LegViewData)
		case didLongTapOnLeg(leg : LegViewData)
		case didCloseActionSheet
		
		case didTapBottomSheetDetails(leg : LegViewData, type : BottomSheetType)
		case didCloseBottomSheet
		
		var description : String {
			switch self {
			case .didRequestReloadIfNeeded:
				return "didRequestReloadIfNeeded"
			case .didChangedSubscribingState:
				return "didChangedSubscribingState"
			case .didTapSubscribingButton:
				return "didTapSubscribingButton"
			case .didLoadJourneyData:
				return "didLoadJourneyData"
			case .didFailedToLoadJourneyData:
				return "didFailedToLoadJourneyData"
			case .didTapReloadButton:
				return "didReloadJourneyList"
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

