//
//  SearchLocationVM+reduce.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 06.09.23.
//

import Foundation

extension SearchLocationViewModel {
	func transform(_ state: State, _ event: Event){
//		print(">>> transform")
		switch event {
		case .onSearchFieldDidChanged(let string, let type):
			break
		case .onDataLoaded(let stops, let type):
			switch type {
			case .departure:
				self.searchLocationDataSource.searchLocationDataDeparture = stops
			case .arrival:
				self.searchLocationDataSource.searchLocationDataArrival = stops
			}
		case .onDataLoadError(_):
			break
		case .onReset(_):
			self.searchLocationDataSource.searchLocationDataArrival = []
			self.searchLocationDataSource.searchLocationDataDeparture = []
		case .onStopDidTap(let stop, let type):
			switch type {
			case .departure:
				topSearchFieldText = stop.name ?? "<^.^>"
			case .arrival:
				bottomSearchFieldText = stop.name ?? "<^.^>"
			}
			self.searchLocationDataSource.searchLocationDataArrival = []
			self.searchLocationDataSource.searchLocationDataDeparture = []
		}
	}
}

extension SearchLocationViewModel {
	func reduce(_ state: State, _ event: Event) -> State {
		transform(state, event)
		print(">>> reduce event:",event.description)
		switch state {
		case .idle:
			switch event {
			case .onSearchFieldDidChanged(let string, let type):
				return .loading(string,type)
			default:
				return state
			}
		case .loading:
			switch event {
			case .onDataLoaded:
				return .loaded
			case .onDataLoadError:
				return .error
			case .onSearchFieldDidChanged(let string, let type):
				return .loading(string,type)
			case .onReset(_):
				return .idle
			case .onStopDidTap(_):
				return .idle
			}
		case .loaded:
			switch event {
			case .onSearchFieldDidChanged(let string, let type):
				return .loading(string,type)
			case .onDataLoaded, .onDataLoadError:
				return state
			case .onStopDidTap(_):
				return .idle
			case .onReset(_):
				return .idle
			}
		case .error:
			switch event {
			case .onSearchFieldDidChanged(let string, let type):
				return .loading(string,type)
			case .onStopDidTap(_):
				return .idle
			case .onDataLoaded, .onDataLoadError:
				return state
			case .onReset(_):
				return .idle
			}
		}
	}
}
