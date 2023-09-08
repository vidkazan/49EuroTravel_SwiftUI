//
//  SearchLocationVM+state.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 06.09.23.
//

import Foundation

extension SearchLocationViewModel {
	struct State {
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
		case loaded
		case error

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
			}
		}
	}
	
	enum Event {
		case onSearchFieldDidChanged(String,LocationDirectionType)
		case onDataLoaded([Stop],LocationDirectionType)
		case onDataLoadError(Error)
		case onReset(LocationDirectionType)
		case onStopDidTap(Stop, LocationDirectionType)
		
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
			}
		}
			
	}
}
