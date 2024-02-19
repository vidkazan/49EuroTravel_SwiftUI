//
//  SheetViewModel.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 07.02.24.
//

import Foundation
import Combine
import SwiftUI
import MapKit
import CoreLocation

class SheetViewModel : ObservableObject, Identifiable {
	@Published private(set) var state : State
//	{
//		didSet { print(">> state:",state.status.description) }
//	}
	
	private var bag = Set<AnyCancellable>()
	private let input = PassthroughSubject<Event,Never>()
	
	
	init(_ initaialStatus : Status = .loading(.none)) {
		self.state = State(
			status: initaialStatus
		)
		Publishers.system(
			initial: state,
			reduce: Self.reduce,
			scheduler: RunLoop.main,
			feedbacks: [
				Self.userInput(input: input.eraseToAnyPublisher()),
				Self.whenLoading()
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

protocol SheetViewDataSource {
}


struct MapLegData {
	let type : LegViewData.LegType
	let stops : [StopViewData]
	let route : MKPolyline?
}

enum MapDetailsRequest {
	case footDirection(_ leg : LegViewData)
	case lineLeg(_ leg : LegViewData)
	case journey(_ legs : [LegViewData])
}

struct MapDetailsViewDataSource : SheetViewDataSource {
	let coordRegion : MKCoordinateRegion
	let mapLegDataList : [MapLegData]
}

struct MapPickerViewDataSource : SheetViewDataSource {
}

struct FullLegViewDataSource : SheetViewDataSource {
	let leg : LegViewData
}

struct DatePickerViewDataSource : SheetViewDataSource {
	
}

struct EmptyDataSource : SheetViewDataSource {
	
}

struct SettingsViewDataSource : SheetViewDataSource {

}
struct OnboardingViewDataSource : SheetViewDataSource {
	
}
struct RemarksViewDataSource : SheetViewDataSource {
	let remarks : [RemarkViewData]
}

extension SheetViewModel{
	struct State  {
		let status : Status
	}
	
	
	enum Status {
		static func == (lhs: SheetViewModel.Status, rhs: SheetViewModel.Status) -> Bool {
			return lhs.description == rhs.description
		}
		case loading(_ type : SheetType)
		case error(_ error : any ChewError)
		case showing(_ type : SheetType, result: any SheetViewDataSource)
		
		var description : String {
			switch self {
			case .error(let error):
				return "error: \(error.localizedDescription)"
			case .showing(let type,_):
				return "showing \(type.description)"
			case .loading(let type):
				return "loading \(type.description)"
			}
		}
	}
	
	enum Event {
		case didRequestShow(_ type : SheetType)
		case didLoadDataForShowing(_ type : SheetType,_ result : SheetViewDataSource)
		case didFailToLoadData(_ error : any ChewError)
		
		var description : String {
			switch self {
			case .didFailToLoadData(let error):
				return "didFailToLoadData \(error.localizedDescription)"
			case .didLoadDataForShowing:
				return "didLoadDataForShowing"
			case .didRequestShow(let type):
				return "didRequestShow \(type.description)"
			}
		}
	}
	enum SheetType : Equatable {
		static func == (lhs: SheetViewModel.SheetType, rhs: SheetViewModel.SheetType) -> Bool {
			lhs.description == rhs.description
		}
		
		case none
		case date
		case settings
		case fullLeg(leg : LegViewData)
		case mapDetails(_ request : MapDetailsRequest)
		case mapPicker(type : LocationDirectionType)
		case onboarding
		case remark(remarks : [RemarkViewData])
		
		var description : String {
			switch self {
			case .mapPicker:
				return "mapPicker"
			case .none:
				return "none"
			case .date:
				return "date"
			case .settings:
				return "settings"
			case .fullLeg:
				return "fullLeg"
			case .mapDetails:
				return "map"
			case .onboarding:
				return "onboarding"
			case .remark:
				return "remark"
			}
		}
		
		var dataSourceType : any SheetViewDataSource.Type {
			switch self {
			case .none:
				return EmptyDataSource.self
			case .mapPicker:
				return MapPickerViewDataSource.self
			case .date:
				return DatePickerViewDataSource.self
			case .settings:
				return SettingsViewDataSource.self
			case .fullLeg:
				return FullLegViewDataSource.self
			case .mapDetails:
				return MapDetailsViewDataSource.self
			case .onboarding:
				return OnboardingViewDataSource.self
			case .remark:
				return RemarksViewDataSource.self
			}
		}
	}
}


extension SheetViewModel {
	static func reduce(_ state: State, _ event: Event) -> State {
//		print(">> ",event.description,"state:",state.status.description)
		switch state.status {
		case .loading:
			switch event {
			case .didRequestShow(let type):
				return State(status: .loading(type))
			case .didFailToLoadData(let error):
				return State(status: .error(error))
			case let .didLoadDataForShowing(type,data):
				return State(status: .showing(type,result: data))
			}
		case .showing,.error:
			switch event {
			case .didRequestShow(let type):
				return State(status: .loading(type))
			case .didFailToLoadData:
				return state
			case .didLoadDataForShowing:
				return state
			}
		}
	}
}

extension SheetViewModel {
	static func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
		Feedback { _ in
			return input
		}
	}
	
	static func whenLoading() -> Feedback<State, Event> {
		Feedback { (state: State) -> AnyPublisher<Event, Never> in
			guard case let .loading(type) = state.status else {
				return Empty().eraseToAnyPublisher()
			}
			switch type {
			case .mapPicker:
				return Just(Event.didLoadDataForShowing(type,MapPickerViewDataSource())).eraseToAnyPublisher()
			case .none:
				return Just(Event.didLoadDataForShowing(type,EmptyDataSource())).eraseToAnyPublisher()
			case .date:
				return Just(Event.didLoadDataForShowing(type,DatePickerViewDataSource())).eraseToAnyPublisher()
			case .settings:
				return Just(Event.didLoadDataForShowing(type,SettingsViewDataSource())).eraseToAnyPublisher()
			case .fullLeg(leg: let leg):
				return loadingFullLeg(state: state, tripId: leg.tripId)
			case .mapDetails(let request):
				return loadingLocationDetails(state: state, request: request)
			case .onboarding:
				return Just(Event.didLoadDataForShowing(type,OnboardingViewDataSource())).eraseToAnyPublisher()
			case .remark(let remarks):
				return Just(Event.didLoadDataForShowing(type,RemarksViewDataSource(remarks: remarks))).eraseToAnyPublisher()
			}
		}
	}
}


extension SheetViewModel {
	static 	func loadingFullLeg(state : State, tripId : String) -> AnyPublisher<Event, Never> {
		return Self.fetchTrip(tripId: tripId)
			.mapError{ $0 }
			.asyncFlatMap {  res in
				let leg = try res.legViewDataThrows(
					firstTS: DateParcer.getDateFromDateString(dateString: res.plannedDeparture),
					lastTS: DateParcer.getDateFromDateString(dateString: res.plannedArrival),
					legs: nil
				)
				return Event.didLoadDataForShowing(.fullLeg(leg: leg),FullLegViewDataSource(leg: leg))
			}
			.catch { error in
				Model.shared.topBarAlertViewModel.send(event: .didRequestShow(.fullLegError))
				return Just(Event.didRequestShow(.none)).eraseToAnyPublisher()
			}
			.eraseToAnyPublisher()
	}

	static func fetchTrip(tripId : String) -> AnyPublisher<LegDTO,ApiError> {
		return ApiService().fetch(
			TripDTO.self,
			query: [],
			type: ApiService.Requests.trips(tripId: tripId)
		)
		.map { $0.trip }
		.eraseToAnyPublisher()
	}
}

extension SheetViewModel {
	private static func constructMapRegion(locFirst : CLLocationCoordinate2D, locLast : CLLocationCoordinate2D) -> MKCoordinateRegion {
		let centerCoordinate = CLLocationCoordinate2D(
			latitude: (locFirst.latitude + locLast.latitude) / 2,
			longitude: (locFirst.longitude + locLast.longitude) / 2
		)
		
		// Calculate the span (delta) between the two coordinates
		let latitudinalDelta = abs(locFirst.latitude - locLast.latitude)
		let longitudinalDelta = abs(locFirst.longitude - locLast.longitude)
		
		// Add a little padding to the span
		let span = MKCoordinateSpan(
			latitudeDelta: latitudinalDelta * 2 + 0.006,
			longitudeDelta: longitudinalDelta * 2 + 0.006
		)
		
		// Create and return the region
		return MKCoordinateRegion(center: centerCoordinate, span: span)
	}
	
	
	static func makeDirectionsRequest(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D
	) -> AnyPublisher<MKDirections.Response, ApiError> {
		let request = MKDirections.Request()
		request.source = MKMapItem(
			placemark: MKPlacemark(
				coordinate: from,
				addressDictionary: nil
			)
		)
		request.destination = MKMapItem(
			placemark: MKPlacemark(
				coordinate: to,
				addressDictionary: nil
			)
		)
		request.transportType = .walking
	
		let directions = MKDirections(request: request)
		
		
		let subject = Future<MKDirections.Response,ApiError> { promise in
			directions.calculate { resp, error in
				if let error=error {
					return promise(.failure(.cannotConnectToHost(error.localizedDescription)))
				}
				guard let resp = resp else {
					return promise(.failure(ApiError.cannotDecodeRawData))
				}
				return promise(.success(resp))
			}
		}
		return subject.eraseToAnyPublisher()
	}
	
	
	static 	func loadingLocationDetails(state : State, request : MapDetailsRequest) -> AnyPublisher<Event, Never> {
		switch request {
		case .footDirection(let leg):
			return footDirectionPath(leg: leg)
		case .lineLeg(let leg):
			if let locFirst = leg.legStopsViewData.first,
			   let locLast = leg.legStopsViewData.last {
				guard let mapLegData = mapLegData(leg: leg) else {
					return Just(Event.didFailToLoadData(DataError.nilValue(type: "mapLegData"))).eraseToAnyPublisher()
				}
				return Just(Event.didLoadDataForShowing(
					.mapDetails(request),
					MapDetailsViewDataSource(
						coordRegion: constructMapRegion(
							locFirst: locFirst.locationCoordinates,
							locLast: locLast.locationCoordinates
						),
						mapLegDataList: [mapLegData]
					)
				)).eraseToAnyPublisher()
			}
		case .journey(let legs):
			if let locFirst = legs.first?.legStopsViewData.first,
			   let locLast = legs.last?.legStopsViewData.last {
				let mapLegDataList = legs.compactMap({mapLegData(leg: $0)})
				return Just(Event.didLoadDataForShowing(
					.mapDetails(request),
					MapDetailsViewDataSource(
						coordRegion: constructMapRegion(
							locFirst: locFirst.locationCoordinates,
							locLast: locLast.locationCoordinates
						),
						mapLegDataList: mapLegDataList
					)
				)).eraseToAnyPublisher()
			}
		}
		
		
		return Empty().eraseToAnyPublisher()
	}
	
	private static func mapLegData(leg : LegViewData) -> MapLegData? {
		if let locFirst = leg.legStopsViewData.first,
		   let locLast = leg.legStopsViewData.last {
			switch leg.legType {
			case .footEnd,.footMiddle,.footStart:
				var polyline : MKPolyline? = nil
				let polylinePoints = leg.legStopsViewData.compactMap {
					return $0.locationCoordinates
				}
				polyline = MKPolyline(coordinates: polylinePoints, count: polylinePoints.count)
				return MapLegData(
					type: leg.legType,
					stops: leg.legStopsViewData,
					route: polyline
				)
			case .line:
				var polyline : MKPolyline? = nil
				if let features = leg.polyline?.features {
					let polylinePoints = features.compactMap {
						if let lat = $0.geometry?.coordinates[1],let long = $0.geometry?.coordinates[0] {
							return CLLocationCoordinate2DMake(lat, long)
						}
						return nil
					}
					polyline = MKPolyline(coordinates: polylinePoints, count: polylinePoints.count)
				} else {
					let polylinePoints = leg.legStopsViewData.compactMap {
						return $0.locationCoordinates
					}
					polyline = MKPolyline(coordinates: polylinePoints, count: polylinePoints.count)
				}
				return MapLegData(
					type: leg.legType,
					stops: leg.legStopsViewData,
					route: polyline
				)
			case .transfer:
				return MapLegData(
					type: leg.legType,
					stops: [locFirst,locLast],
					route: nil
				)
			}
		}
		return nil
	}
	
	private static func footDirectionPath(leg : LegViewData) -> AnyPublisher<Event, Never> {
		guard let locFirst = leg.legStopsViewData.first,
			  let locLast = leg.legStopsViewData.last else {
			return Just(Event.didFailToLoadData(DataError.nilValue(type: "start/end stop"))).eraseToAnyPublisher()
		}
			switch leg.legType {
			case .line,.transfer:
				return Just(Event.didFailToLoadData(DataError.generic(msg: "\(#function): wrong type"))).eraseToAnyPublisher()
			case .footEnd,.footMiddle,.footStart:
				let mapRegion = constructMapRegion(
					locFirst: locFirst.locationCoordinates,
					locLast: locLast.locationCoordinates
				)
				return makeDirectionsRequest(from: locFirst.locationCoordinates, to: locLast.locationCoordinates)
					.map { res in
						return Event.didLoadDataForShowing(
							.mapDetails(.footDirection(leg)),
							MapDetailsViewDataSource(
								coordRegion: mapRegion,
								mapLegDataList: [
									MapLegData(
										type: leg.legType,
										stops: [locFirst,locLast],
										route: res.routes.first?.polyline
									)
								]
							)
						)
					}
					.catch { error in
						print("❌ whenLoadingLocationDetails: makeDirecitonsRequest: error:",error)
						return Just(Event.didLoadDataForShowing(
							.mapDetails(.footDirection(leg)),
							MapDetailsViewDataSource(
								coordRegion: mapRegion,
								mapLegDataList: [
									MapLegData(
										type: leg.legType,
										stops: [locFirst,locLast],
										route: nil
									)
								]
							)
						))
					}
					.eraseToAnyPublisher()
			}
	}
}
