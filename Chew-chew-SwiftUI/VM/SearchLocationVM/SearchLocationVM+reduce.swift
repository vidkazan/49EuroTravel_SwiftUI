//
//  SearchLocationVM+reduce.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 06.09.23.
//

import Foundation

extension SearchLocationViewModel {
	func reduce(_ state:  State, _ event: Event) -> State {
		print(":: reduce event:",event.description)
		
		switch state.status {
		case .idle:
			switch event {
			case .onSearchFieldDidChanged(let string, let type):
				return State(
					stops: state.stops,
					previousSearchLineString: state.previousSearchLineString,
					status: .loading(string, type),
					type: state.type
				)
			default:
				return state
			}
		case .loading:
			switch event {
			case .onDataLoaded(let stops, let type):
				return State(
					stops: stops,
					previousSearchLineString: state.previousSearchLineString,
					status: .loaded,
					type: type
				)
			case .onDataLoadError:
				return State(
					stops: [],
					previousSearchLineString: state.previousSearchLineString,
					status: .error,
					type: state.type
				)
			case .onSearchFieldDidChanged(let string, let type):
				return State(
					stops: state.stops,
					previousSearchLineString: state.previousSearchLineString,
					status: .loading(string, type),
					type: type
				)
			case .onReset(_):
				return State(
					stops: [],
					previousSearchLineString: "",
					status: .idle,
					type: state.type
				)
			case .onStopDidTap((_), let type):
				return State(
					stops: [],
					previousSearchLineString: "",
					status: .idle,
					type: type
				)
			}
		case .loaded:
			switch event {
			case .onSearchFieldDidChanged(let string, let type):
				return State(
					stops: state.stops,
					previousSearchLineString: state.previousSearchLineString,
					status: .loading(string, type),
					type: state.type
				)
			case .onDataLoaded, .onDataLoadError:
				return state
			case .onStopDidTap((_), let type):
				return State(
					stops: [],
					previousSearchLineString: "",
					status: .idle,
					type: state.type
				)
			case .onReset(_):
				return State(
					stops: [],
					previousSearchLineString: "",
					status: .idle,
					type: state.type
				)
			}
		case .error:
			switch event {
			case .onSearchFieldDidChanged(let string, let type):
				return State(
					stops: state.stops,
					previousSearchLineString: state.previousSearchLineString,
					status: .loading(string, type),
					type: state.type
				)
			case .onStopDidTap(let stop, let type):
				return State(
					stops: [],
					previousSearchLineString: "",
					status: .idle,
					type: state.type
				)
			case .onDataLoaded, .onDataLoadError:
				return state
			case .onReset(_):
				return State(
					stops: [],
					previousSearchLineString: "",
					status: .idle,
					type: state.type
				)
			}
		}
	}
}
