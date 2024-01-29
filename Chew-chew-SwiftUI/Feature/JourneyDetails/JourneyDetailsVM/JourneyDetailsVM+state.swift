//
//  JourneyDetailsVM+state.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.09.23.
//
import Foundation
import MapKit

extension JourneyDetailsViewModel {
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
	enum BottomSheetType : Equatable,Hashable {
		case locationDetails
		case fullLeg
	}
	
	struct StateData : Equatable {
		static func == (lhs: JourneyDetailsViewModel.StateData, rhs: JourneyDetailsViewModel.StateData) -> Bool {
			lhs.depStop == rhs.depStop &&
			lhs.arrStop == rhs.arrStop &&
			lhs.viewData == rhs.viewData &&
			lhs.isFollowed == rhs.isFollowed
		}
		
		weak var chewVM : ChewViewModel?
		let depStop : Stop
		let arrStop : Stop
		let viewData : JourneyViewData
		let isFollowed : Bool
		
		
		init(depStop: Stop, arrStop: Stop, viewData: JourneyViewData, isFollowed: Bool, chewVM : ChewViewModel?) {
			self.depStop = depStop
			self.arrStop = arrStop
			self.viewData = viewData
			self.isFollowed = isFollowed
			self.chewVM = chewVM
		}
		
		init(currentData : Self, isFollowed: Bool) {
			self.chewVM = currentData.chewVM
			self.depStop = currentData.depStop
			self.arrStop = currentData.arrStop
			self.viewData = currentData.viewData
			self.isFollowed = isFollowed
		}
		
		init(currentData : Self, viewData : JourneyViewData) {
			self.chewVM = currentData.chewVM
			self.depStop = currentData.depStop
			self.arrStop = currentData.arrStop
			self.viewData = viewData
			self.isFollowed = currentData.isFollowed
		}
		
	}
	
	struct State : Equatable {
		let data : StateData
		let status : Status
		
		
		init(data : StateData, status : Status){
			self.data = data
			self.status = status
		}
		
		init(chewVM : ChewViewModel?,depStop: Stop, arrStop: Stop,viewData: JourneyViewData, status: Status, followList : [String]) {
			self.data = StateData(
				depStop: depStop,
				arrStop: arrStop,
				viewData: viewData,
				isFollowed: followList.contains(where: {$0 == viewData.refreshToken}),
				chewVM: chewVM
			)
			self.status = status
		}
		init(chewVM: ChewViewModel?,depStop: Stop, arrStop: Stop,viewData: JourneyViewData, status: Status, isFollowed : Bool) {
			self.data = StateData(
				depStop: depStop,
				arrStop: arrStop,
				viewData: viewData,
				isFollowed: isFollowed,
				chewVM: chewVM
			)
			self.status = status
		}
	}
	
	enum Status : Equatable {
		static func == (lhs: JourneyDetailsViewModel.Status, rhs: JourneyDetailsViewModel.Status) -> Bool {
			return lhs.description == rhs.description
		}
		case loading(token : String)
		case loadingIfNeeded(token : String)
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
		
		case changingSubscribingState(ref : String, journeyDetailsViewModel: JourneyDetailsViewModel?)
		
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
			case .error(let error):
				return "error: \(error)"
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
		
		
		case didRequestReloadIfNeeded(ref : String)
		case didTapReloadButton(ref : String)
		case didTapSubscribingButton(ref : String,journeyDetailsViewModel: JourneyDetailsViewModel?)
		
		case didExpandLegDetails
		case didLoadLocationDetails(
			coordRegion : MKCoordinateRegion,
			stops : [StopViewData],
			route : MKPolyline?
		)
		
		case didFailToChangeSubscribingState(error : any ChewError)
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
			case .didFailToChangeSubscribingState(let error):
				return "didFailToChangeSubscribingState \(error)"
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

