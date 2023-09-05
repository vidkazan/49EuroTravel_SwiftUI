//
//  SearchStopViewModel.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 03.09.23.
//

import Foundation
import Combine

final class SearchJourneyViewModel : ObservableObject {
	@Published private(set) var state : State {
		didSet {
			print(">> state: ",state.description)
		}
	}
	private var bag = Set<AnyCancellable>()
	private let input = PassthroughSubject<Event,Never>()
	
	init() {
		self.state = .idle
		Publishers.system(
			initial: .idle,
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


extension SearchJourneyViewModel {
	func reduce(_ state: State, _ event: Event) -> State {
		print(">> event:",event)
		switch state {
		case .idle:
			switch event {
			case .onJourneyDataUpdated:
				return .loadingJourneys
			case .onDepartureEdit:
				return .editingDepartureStop
			case .onArrivalEdit:
				return .editingArrivalStop
			case .onDatePickerDidPressed:
				return .datePicker
			default:
				return state
			}
		case .editingDepartureStop:
			switch event {
			case .onArrivalEdit:
				return .editingArrivalStop
			case .onDatePickerDidPressed:
				return .datePicker
			default:
				return state
			}
		case .editingArrivalStop:
			switch event {
			case .onDepartureEdit:
				return .editingDepartureStop
			case .onDatePickerDidPressed:
				return .datePicker
			default:
				return state
			}
		case .datePicker:
			switch event {
			case .onNewDate:
				return .idle
			default:
				return state
			}
		case .loadingJourneys:
			switch event {
			case .onResetJourneyView, .onStopsSwitch, .onNewDate:
				return .idle
			case .onDepartureEdit:
				return .editingDepartureStop
			case .onArrivalEdit:
				return .editingArrivalStop
			case .onDatePickerDidPressed:
				return .datePicker
			default:
				return state
			}
		case .journeysLoaded:
			switch event {
			case .onResetJourneyView, .onStopsSwitch, .onNewDate:
				return .idle
			case .onDepartureEdit:
				return .editingDepartureStop
			case .onArrivalEdit:
				return .editingArrivalStop
			case .onDatePickerDidPressed:
				return .datePicker
			case .onReloadJourneys, .onLaterRef, .onEarlierRef:
				return .loadingJourneys
			case .onJourneyDidPressed:
				return .journeyDetails
			default:
				return state
			}
		case .journeyDetails:
			switch event {
			case .onBackFromJourneyDetails:
				return .journeysLoaded
			default:
				return state
			}
		case .failedToLoadJourneys:
			switch event {
			case .onResetJourneyView, .onStopsSwitch, .onNewDate:
				return .idle
			case .onDepartureEdit:
				return .editingDepartureStop
			case .onArrivalEdit:
				return .editingArrivalStop
			case .onDatePickerDidPressed:
				return .datePicker
			default:
				return state
			}
		}
	}
}

extension SearchJourneyViewModel {
	static func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
		Feedback { _ in
			input
		}
	}
	
//	static func whenLoadingJourneys() -> Feedback<State, Event> {
//	  Feedback { (state: State) -> AnyPublisher<Event, Never> in
//		  // 1.
//		  guard case .loadingJourneys = state else { return Empty().eraseToAnyPublisher() }
//
//		  // 2.
//		  return SearchLocationViewModel.fetchLocationsCombine(text: "pop", type: .departure)
//			  .map([Stop].init)
//			  .map(Event.onNewJourneysData)
//			  // 4.
//			  .catch { Just(Event.onFailedToLoadStops($0)) }
//			  .eraseToAnyPublisher()
//	  }
//	}
}


extension SearchJourneyViewModel {
	enum State : Equatable {
		static func == (lhs: SearchJourneyViewModel.State, rhs: SearchJourneyViewModel.State) -> Bool {
			return lhs.description == rhs.description
		}
		
		case idle
		case editingDepartureStop
		case editingArrivalStop
		case datePicker
		case loadingJourneys
		case journeysLoaded
		case journeyDetails
		case failedToLoadJourneys
		
		var description : String {
			switch self {
			case .idle:
				return "idle"
			case .editingDepartureStop:
				return "editingDepartureStop"
			case .editingArrivalStop:
				return "editingArrivalStop"
			case .datePicker:
				return "datePicker"
			case .loadingJourneys:
				return "loadingJourneys"
			case .journeyDetails:
				return "journeyDetails"
			case .failedToLoadJourneys:
				return "failedToLoadJourneys"
			case .journeysLoaded:
				return "journeysLoaded"
			}
		}
	}
	
//	enum SearchFieldState {
//		case idle(String)
//		case loading(String)
//	}
//	enum StopListState {
//		case idle
//		case loaded([Stop])
//		case error(CustomErrors)
//	}
	enum Event {
		case onDepartureEdit
		case onArrivalEdit
		
		case onDatePickerDidPressed
		
		case onNewDeparture
		case onNewArrival
		case onResetJourneyView
		case onStopsSwitch
		case onNewDate
		
		case onJourneyDataUpdated
		
		case onNewJourneysData
		case onFailedToLoadJourneysData
		
		case onJourneyDidPressed
		case onBackFromJourneyDetails
		
		case onReloadJourneys
		case onLaterRef
		case onEarlierRef
	}
}
