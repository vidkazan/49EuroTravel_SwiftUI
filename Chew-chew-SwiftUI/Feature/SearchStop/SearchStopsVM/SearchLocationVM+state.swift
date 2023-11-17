//
//  SearchLocationVM+state.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 06.09.23.
//

import Foundation

extension SearchStopsViewModel {
	
	struct State : Equatable {
		var previousStops : [Stop]
		var stops : [Stop]
		var status : Status
		var type : LocationDirectionType?
	}
	
	enum Status : Equatable,Hashable {
		static func == (lhs: SearchStopsViewModel.Status, rhs: SearchStopsViewModel.Status) -> Bool {
			return lhs.description == rhs.description
		}
		case idle
		case loading(String)
		case loaded
		case updatingRecentStops(Stop)
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
			case .updatingRecentStops:
				return "updatingRecentStops"
			}
		}
	}
	
	enum Event {
		case onSearchFieldDidChanged(String,LocationDirectionType)
		case onDataLoaded([Stop],LocationDirectionType)
		case onDataLoadError(ApiServiceError)
		case onReset(LocationDirectionType)
		case onStopDidTap(Stop, LocationDirectionType)
		case didRecentStopsUpdated(recentStops : [Stop])
		
		
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
			case .didRecentStopsUpdated:
				return "didRecentStopsUpdated"
			}
		}
	}
}
