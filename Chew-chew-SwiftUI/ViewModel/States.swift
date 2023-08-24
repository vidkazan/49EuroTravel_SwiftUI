//
//  States.swift
//  49EuroTravel
//
//  Created by Dmitrii Grigorev on 09.08.23.
//

import Foundation

enum SearchControllerStates {
	case onStart
//	case onLoading
	case onNewDataDepartureStop
	case onNewDataArrivalStop
	case onNewDataJourney
	case onError(error : CustomErrors, indexPath : IndexPath?)
	
	var description : String {
		switch self {
		case .onStart:
			return "onStart"
//		case .onLoading:
//			return "onLoading"
		case .onNewDataDepartureStop:
			return "onNewDataDepartureStop"
		case .onNewDataArrivalStop:
			return "onNewDataArrivalStop"
		case .onNewDataJourney:
			return "onNewDataJourney"
		case .onError:
			return "onError"
		}
	}
}
