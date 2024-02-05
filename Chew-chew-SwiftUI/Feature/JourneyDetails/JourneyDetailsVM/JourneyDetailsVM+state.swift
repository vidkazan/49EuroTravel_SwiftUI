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
			lhs.viewData == rhs.viewData
		}
		
		let id : Int64
		weak var chewVM : ChewViewModel?
		let depStop : Stop
		let arrStop : Stop
		let viewData : JourneyViewData
		
		
		init(followId: Int64,depStop: Stop, arrStop: Stop, viewData: JourneyViewData, chewVM : ChewViewModel?) {
			self.id = followId
			self.depStop = depStop
			self.arrStop = arrStop
			self.viewData = viewData
			self.chewVM = chewVM
		}
		
		init(currentData : Self) {
			self.id = currentData.id
			self.chewVM = currentData.chewVM
			self.depStop = currentData.depStop
			self.arrStop = currentData.arrStop
			self.viewData = currentData.viewData
		}
		
		init(currentData : Self, viewData : JourneyViewData) {
			self.id = currentData.id
			self.chewVM = currentData.chewVM
			self.depStop = currentData.depStop
			self.arrStop = currentData.arrStop
			self.viewData = viewData
		}
		
	}
	
	struct State : Equatable {
		let data : StateData
		let status : Status
		
		
		init(data : StateData, status : Status){
			self.data = data
			self.status = status
		}
		
		init(followId: Int64,chewVM : ChewViewModel?,depStop: Stop, arrStop: Stop,viewData: JourneyViewData, status: Status) {
			self.data = StateData(
				followId: followId,
				depStop: depStop,
				arrStop: arrStop,
				viewData: viewData,
				chewVM: chewVM
			)
			self.status = status
		}
	}
	
	enum Status : Equatable {
		static func == (lhs: JourneyDetailsViewModel.Status, rhs: JourneyDetailsViewModel.Status) -> Bool {
			return lhs.description == rhs.description
		}
		case loading(id : Int64,token : String)
		case loadingIfNeeded(id : Int64,token : String,timeStatus: TimeContainer.Status)
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
		
		case changingSubscribingState(id: Int64, ref : String, journeyDetailsViewModel: JourneyDetailsViewModel?)
		
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
			case .loadingFullLeg:
				return "loadingFullLeg"
			}
		}
	}
	
	enum Event {
		case didFailToLoadTripData(error : any ChewError)
		case didCancelToLoadData
		case didLoadJourneyData(data : JourneyViewData)
		case didFailedToLoadJourneyData(error : any ChewError)
		
		
		case didRequestReloadIfNeeded(id: Int64, ref : String,timeStatus: TimeContainer.Status)
		case didTapReloadButton(id : Int64, ref : String)
		case didTapSubscribingButton(id : Int64, ref : String,journeyDetailsViewModel: JourneyDetailsViewModel?)
		
		case didLoadLocationDetails(
			coordRegion : MKCoordinateRegion,
			stops : [StopViewData],
			route : MKPolyline?
		)
		
		case didFailToChangeSubscribingState(error : any ChewError)
		case didChangedSubscribingState
		case didLoadFullLegData(data : LegViewData)
		
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
			case .didLoadLocationDetails:
				return "didLoadLocationDetails"
			case .didTapBottomSheetDetails:
				return "didCloseActionSheet"
			case .didCloseBottomSheet:
				return "didCloseBottomSheet"
			case .didLoadFullLegData:
				return "didLoadFullLegData"
			case .didCancelToLoadData:
				return "didCancelToLoadData"
			}
		}
	}
}

