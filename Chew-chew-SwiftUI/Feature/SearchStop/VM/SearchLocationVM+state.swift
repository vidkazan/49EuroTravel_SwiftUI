//
//  SearchLocationVM+state.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 06.09.23.
//

import Foundation

extension SearchLocationViewModel {
	
	struct State : Equatable {
		var stops : [Stop]
		var previousSearchLineString : String
		var status : Status
		var type : LocationDirectionType
	}
	
	enum Status : Equatable {
		static func == (lhs: SearchLocationViewModel.Status, rhs: SearchLocationViewModel.Status) -> Bool {
			return lhs.description == rhs.description
		}
		case idle
		case loading(String,LocationDirectionType)
//		case loadingLocation
//		case loadedUserLocation(lat: Double,long: Double)
		case loaded
		case error(ApiServiceError)

		var description : String {
			switch self {
			case .idle:
				return "idle"
			case .loading:
				return "loading"
			case .loaded:
				return "loaded"
			case .error:
				return "error"
//			case .loadingLocation:
//				return "loadingLocation"
//			case .loadedUserLocation:
//				return "loadedUserLocation"
			}
		}
	}
	
	enum Event {
		case onSearchFieldDidChanged(String,LocationDirectionType)
		case onDataLoaded([Stop],LocationDirectionType)
		case onDataLoadError(ApiServiceError)
		case onReset(LocationDirectionType)
		case onStopDidTap(Stop, LocationDirectionType)
//		case didLocationButtonPressed
//		case didReceiveLocaitonData(lat: Double,long: Double)
//		case didFailToLoadLocationData
//		case didSetUserLocationData
		
		
		var description : String {
			switch self {
			case .onSearchFieldDidChanged:
				return "onSearchFieldDidChanged"
			case .onDataLoaded:
				return "onDataLoaded"
			case .onDataLoadError:
				return "onDataLoadError"
			case .onReset:
				return "onReset"
			case .onStopDidTap:
				return "onStopDidTap"
//			case .didReceiveLocaitonData:
//				return "didReceiveLocaitonData"
//			case .didFailToLoadLocationData:
//				return "didFailToLoadLocationData"
//			case .didSetUserLocationData:
//				return "didSetUserLocationData"
//			case .didLocationButtonPressed:
//				return "didLocationButtonPressed"
			}
		}
	}
}
