//
//  MapView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 12.02.24.
//

import Foundation
import Combine
import CoreLocation
import MapKit

class MapPickerViewModel : ObservableObject, Identifiable {
	@Published private(set) var state : State {
		didSet { print(">> state:",state.status.description) }
	}
	private var bag = Set<AnyCancellable>()
	private let input = PassthroughSubject<Event,Never>()
	
	
	init(_ initaialStatus : Status) {
		self.state = State(
			data: StateData(
				stops: [],
				selectedStop: nil
			),
			status: initaialStatus
		)
		Publishers.system(
			initial: state,
			reduce: Self.reduce,
			scheduler: RunLoop.main,
			feedbacks: [
				Self.userInput(input: input.eraseToAnyPublisher()),
				Self.whenLoadingNearbyStops()
			],
			name: ""
		)
		.weakAssign(to: \.state, on: self)
		.store(in: &bag)
	}
	
	deinit {
		bag.removeAll()
	}

	func send(event: Event) {
		input.send(event)
	}
}

extension MapPickerViewModel {
	struct State  {
		let data : StateData
		let status : Status
	}
	
	struct StateData {
		let stops : [Stop]
		let selectedStop : Stop?
	}
	
	enum Status{
		case idle
		case error(any ChewError)
		case submitting(Stop)
		case loadingAddress(Stop)
		case loadingNearbyStops(_ region : MKCoordinateRegion)
		var description : String {
			switch self {
			case .error(let err):
				return "error \(err.localizedDescription)"
			case .submitting:
				return "submitting"
			case .idle:
				return "idle"
			case .loadingAddress(_):
				return "loadingAddress"
			case .loadingNearbyStops(_):
				return "loadingStops"
			}
		}
	}
	
	enum Event {
		case didSubmitStop(Stop)
		case didTapStopOnMap(Stop)
		case didDragMap(_ region : MKCoordinateRegion)
		
		case onNewAddress(Stop)
		
		case onNewNearbyStops([Stop])
		
		case didCancelLoading
		case didFailToLoad(any ChewError)
		var description : String {
			switch self {
			case .didFailToLoad(let err):
				return "didFailToLoad \(err.localizedDescription)"
			case .didCancelLoading:
				return "didCancelLoading"
			case .didSubmitStop(let stop):
				return "didSelectStop \(stop.name)"
			case .didTapStopOnMap(let stop):
				return "didSelectStop \(stop.name)"
			case .didDragMap:
				return "didDragMap"
			case .onNewAddress(_):
				return "onNewAddress"
			case .onNewNearbyStops(_):
				return "onNewNearbyStops"
			}
		}
	}
}


extension MapPickerViewModel {
	static func reduce(_ state: State, _ event: Event) -> State {
		print(">> ",event.description,"state:",state.status.description)
		switch state.status {
		case .idle,.error:
			switch event {
			case .didFailToLoad(let err):
				return State(data: state.data, status: .error(err))
			case .didCancelLoading:
				return state
			case .didSubmitStop(let stop):
				return State(
					data: StateData(
						stops: [],
						selectedStop: nil
					),
					status: .submitting(stop)
				)
			case .didTapStopOnMap(let stop):
				return State(
					data: StateData(
						stops: state.data.stops,
						selectedStop: stop
					),
					status: .loadingAddress(stop)
				)
			case .didDragMap(let coords):
				return State(
					data: state.data,
					status: .loadingNearbyStops(coords)
				)
			case .onNewAddress(let stop):
				return State(
					data: StateData(
						stops: state.data.stops,
						selectedStop: stop.coordinates == state.data.selectedStop?.coordinates ? stop : state.data.selectedStop
					),
					status: .idle
				)
			case .onNewNearbyStops(let stops):
				return State(
					data: StateData(
						stops: stops,
						selectedStop: state.data.selectedStop
					),
					status: .idle
				)
			}
		case .loadingAddress:
			switch event {
			case .didFailToLoad(let err):
				return State(data: state.data, status: .error(err))
			case .didCancelLoading:
				return State(data: state.data, status: .idle)
			case .didSubmitStop(let stop):
				return State(
					data: StateData(
						stops: [],
						selectedStop: nil
					),
					status: .submitting(stop)
				)
			case .didTapStopOnMap(let stop):
				return State(
					data: StateData(
						stops: state.data.stops,
						selectedStop: stop
					),
					status: .loadingAddress(stop)
				)
			case .didDragMap(let coords):
				return State(
					data: state.data,
					status: .loadingNearbyStops(coords)
				)
			case .onNewAddress(let stop):
				return State(
					data: StateData(
						stops: state.data.stops,
						selectedStop: stop.coordinates == state.data.selectedStop?.coordinates ? stop : state.data.selectedStop
					),
					status: .idle
				)
			case .onNewNearbyStops(let stops):
				return State(
					data: StateData(
						stops: stops,
						selectedStop: state.data.selectedStop
					),
					status: .idle
				)
			}
		case .loadingNearbyStops:
			switch event {
			case .didFailToLoad(let err):
				return State(data: state.data, status: .error(err))
			case .didCancelLoading:
				return State(data: state.data, status: .idle)
			case .didSubmitStop(let stop):
				return State(
					data: StateData(
						stops: [],
						selectedStop: nil
					),
					status: .submitting(stop)
				)
			case .didTapStopOnMap(let stop):
				return State(
					data: StateData(
						stops: state.data.stops,
						selectedStop: stop
					),
					status: .loadingAddress(stop)
				)
			case .didDragMap(let coords):
				return State(
					data: state.data,
					status: .loadingNearbyStops(coords)
				)
			case .onNewAddress(let stop):
				return State(
					data: StateData(
						stops: state.data.stops,
						selectedStop: stop.coordinates == state.data.selectedStop?.coordinates ? stop : state.data.selectedStop
					),
					status: .idle
				)
			case .onNewNearbyStops(let stops):
				return State(
					data: StateData(
						stops: stops,
						selectedStop: state.data.selectedStop
					),
					status: .idle
				)
			}
		case .submitting:
			return state
		}
	}
}

extension MapPickerViewModel {
	static func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
		Feedback { _ in
			return input
		}
	}
	
	static func whenLoadingNearbyStops() -> Feedback<State, Event> {
		Feedback { (state: State) -> AnyPublisher<Event, Never> in
			guard case .loadingNearbyStops(let region) = state.status else {
				return Empty().eraseToAnyPublisher()
			}
			if region.span.longitudeDelta > 0.02 {
				return Just(Event.didCancelLoading).eraseToAnyPublisher()
			}
			return Self.fetchLocatonsNearby(coords: region.center)
				.mapError{ $0 }
				.asyncFlatMap { res in
					let stops = res.compactMap({$0.stop()})
					return Event.onNewNearbyStops(stops)
				}
				.catch { error in
					return Just(Event.didFailToLoad(error as? ApiServiceError ?? .badRequest)).eraseToAnyPublisher()
				}
				.eraseToAnyPublisher()
		}
	}
	
	static func fetchLocatonsNearby(coords : CLLocationCoordinate2D) -> AnyPublisher<[StopDTO],ApiServiceError> {
		return ApiService().fetch(
			[StopDTO].self,
			query: [
				Query.longitude(longitude: String(coords.longitude)).queryItem(),
				Query.latitude(latitude: String(coords.latitude)).queryItem()
			],
			type: ApiService.Requests.locationsNearby(coords: coords)
		)
		.eraseToAnyPublisher()
	}
}

