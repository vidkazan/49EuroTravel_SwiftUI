//
//  SearchStopViewModel.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 03.09.23.
//

import Foundation
import Combine

final class SearchStopViewModel : ObservableObject {
	@Published private(set) var state : State = .idle(.idle(""), .idle)
	private var bag = Set<AnyCancellable>()
	private let input = PassthroughSubject<Event,Never>()
	
	init() {
		Publishers.system(
			initial: .idle(.idle(""), .idle),
			reduce: self.reduce,
			scheduler: RunLoop.main,
			feedbacks: [
				Self.userInput(input: input.eraseToAnyPublisher()),
//				Self.whenLoading()
			]
		)
			.assign(to: \.state, on: self)
			.store(in: &bag)
		}
	deinit {
		   bag.removeAll()
	   }
	   
	func send(event: Event) {
		input.send(event)
	}
}


extension SearchStopViewModel {
	func reduce(_ state: State, _ event: Event) -> State {
		switch state {
		case .idle(_,_):
			switch event {
			case .onReset:
				return .idle(.idle(""), .idle)
			case .onSearchFieldDidEdited(let string):
				return .loading(.loading(string), .idle)
			case .onFocusEnd:
				return .idle(.idle("focusEnd"), .idle)
			case .onSelectStop(_), .onStopsLoaded(_), .onFailedToLoadStops(_):
				return state
			}
		case .loading(_, _):
			switch event {
			case .onReset:
				return .idle(.idle(""), .idle)
			case .onSearchFieldDidEdited(let string):
				return .loading(.loading(string), .idle)
			case .onFocusEnd:
				return .idle(.idle("focusEnd"), .idle)
			case .onSelectStop(_):
				return state
			case .onStopsLoaded(let array):
				return .loaded(.idle("loaded"), .loaded(array))
			case .onFailedToLoadStops(_):
				return .error(.idle("error"), .error(.init(apiServiceErrors: .badServerResponse(code: 666), source: .customGet(path: "error"))))
			}
		case .loaded(_, _):
			switch event {
			case .onReset:
				return .idle(.idle(""), .idle)
			case .onSearchFieldDidEdited(let string):
				return .loading(.loading(string), .idle)
			case .onFocusEnd:
				return .idle(.idle("focusEnd"), .idle)
			case .onSelectStop(let stop):
				return .idle(.idle(stop.name ?? "no name"), .idle)
			case .onStopsLoaded(_):
				return state
			case .onFailedToLoadStops(_):
				return state
			}
		case .error(_, _):
			switch event {
			case .onReset:
				return .idle(.idle(""), .idle)
			case .onSearchFieldDidEdited(let string):
				return .loading(.loading(string), .idle)
			case .onFocusEnd:
				return .idle(.idle("focusEnd"), .idle)
			case .onSelectStop(_):
				return .idle(.idle(""), .idle)
			case .onStopsLoaded(_):
				return state
			case .onFailedToLoadStops(_):
				return state
			}
		}
	}
}

extension SearchStopViewModel {
	static func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
		Feedback { _ in
			input
		}
	}
	
//	static func whenLoading() -> Feedback<State, Event> {
//	  Feedback { (state: State) -> AnyPublisher<Event, Never> in
//		  // 1.
//		  guard case .loading = state else { return Empty().eraseToAnyPublisher() }
//
//		  // 2.
//		  return SearchLocationViewModel.fetchLocationsCombine(text: "pop", type: .departure)
//			  .map([Stop].init)
//			  .map(Event.onStopsLoaded)
//			  // 4.
//			  .catch { Just(Event.onFailedToLoadStops($0)) }
//			  .eraseToAnyPublisher()
//	  }
//	}
}


extension SearchStopViewModel {
	enum State : Equatable {
		static func == (lhs: SearchStopViewModel.State, rhs: SearchStopViewModel.State) -> Bool {
			switch lhs {
			case .idle(_,_):
				switch rhs {
				case .idle(_,_):
					return true
				default:
					return false
				}
			case .loading(_,_):
				switch lhs {
				case .loading(_,_):
					return true
				default:
					return false
				}
			case .loaded(_,_):
				switch lhs {
				case .loaded(_,_):
					return true
				default:
					return false
				}
			case .error(_,_):
				switch lhs {
				case .error(_,_):
					return true
				default:
					return false
				}
			}
		}
		
		case idle(SearchFieldState,StopListState)
		case loading(SearchFieldState,StopListState)
		case loaded(SearchFieldState,StopListState)
		case error(SearchFieldState,StopListState)
	}
	
	enum SearchFieldState {
		case idle(String)
		case loading(String)
	}
	enum StopListState {
		case idle
		case loaded([Stop])
		case error(CustomErrors)
	}
	enum Event {
		case onReset
		case onSearchFieldDidEdited(String)
		case onFocusEnd
		case onSelectStop(Stop)
		case onStopsLoaded([Stop])
		case onFailedToLoadStops(Error)
	}
}
