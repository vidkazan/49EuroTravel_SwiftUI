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
			#warning("mak new PK for journeys instead of journeyRef(can change after refresh api call)")
			self.data = data
			self.status = status
			self.isFollowed = followList.contains(where: {$0 == data.refreshToken})
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
		case error(error : any ChewError)
		case loadingLocationDetails(leg : LegViewData)
		case locationDetails(
			coordRegion : MKCoordinateRegion,
			stops : [StopViewData],
			route : MKPolyline?
		)
		case fullLeg(leg : LegViewData)
		case loadingFullLeg(leg : LegViewData)
		case actionSheet(leg : LegViewData)
		
		case changingSubscribingState(ref : String)
		
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
		case didFailToLoadTripData(error : any ChewError)
		case didLoadJourneyData(data : JourneyViewData)
		case didFailedToLoadJourneyData(error : any ChewError)
		
		
		case didRequestReloadIfNeeded
		case didTapReloadButton
		case didTapSubscribingButton(ref : String)
		
		case didExpandLegDetails
		case didLoadLocationDetails(
			coordRegion : MKCoordinateRegion,
			stops : [StopViewData],
			route : MKPolyline?
		)
		
		case didFailToChangeSubscribingState
		case didChangedSubscribingState(isFollowed : Bool)
		case didLoadFullLegData(data : LegViewData)
		case didLongTapOnLeg(leg : LegViewData)
		case didCloseActionSheet
		
		case didTapBottomSheetDetails(leg : LegViewData, type : BottomSheetType)
		case didCloseBottomSheet
		
		var description : String {
			switch self {
			case .didFailToLoadTripData(let error):
				return "didFailToLoadTripData \(error)"
			case .didFailToChangeSubscribingState:
				return "didFailToChangeSubscribingState"
			case .didRequestReloadIfNeeded:
				return "didRequestReloadIfNeeded"
			case .didChangedSubscribingState:
				return "didChangedSubscribingState"
			case .didTapSubscribingButton:
				return "didTapSubscribingButton"
			case .didLoadJourneyData:
				return "didLoadJourneyData"
			case .didFailedToLoadJourneyData(let error):
				return "didFailedToLoadJourneyData \(error)"
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

