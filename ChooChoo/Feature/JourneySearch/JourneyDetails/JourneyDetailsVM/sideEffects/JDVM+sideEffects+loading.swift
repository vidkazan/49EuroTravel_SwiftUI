
//
//  JourneyDetailsVM+sideEffect.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.09.23.
//

import Foundation
import Combine
import CoreLocation
import MapKit

extension JourneyDetailsViewModel {

	static func whenLoadingIfNeeded() -> Feedback<State, Event> {
		Feedback {(state: State) -> AnyPublisher<Event, Never> in
			switch state.status {
			case let .loadingIfNeeded(id,token,status):
				if Date.now.timeIntervalSince1970 - state.data.viewData.updatedAt < status.updateIntervalInMinutes * 60 {
					return Just(Event.didCancelToLoadData).eraseToAnyPublisher()
				}
				return Just(Event.didTapReloadButton(id: id,ref: token)).eraseToAnyPublisher()
			default:
				return Empty().eraseToAnyPublisher()
			}
		}
	}
	
//	static func findingTrainArrivalTimeOrigin(
//		jounrey : JourneyViewData,
//		leg : LegViewData
//	) -> JourneyViewData? {
//		let searchArrivalPlatform = leg.legStopsViewData[0].departurePlatform.actual
//		let lineType = leg.lineViewData.type
//		let lineName = leg.lineViewData.name
//		
//		guard leg.legStopsViewData[0].time.date.arrival.planned == nil,
//			let searchDepStop = leg.legStopsViewData[0].stop(),
//			let searchArrStop = leg.legStopsViewData[1].stop(),
//			let searchArrivalTime = leg.time.date.departure.actual,
//			leg.lineViewData.type == .regional || leg.lineViewData.type == .suburban,
//			let stop = leg.legStopsViewData.first
//		else {
//			return nil
//		}
//	
//		var newJourney : JourneyViewData? = nil
//		var journeyListDTO : [JourneyDTO]?
//		
//		ApiService().fetch(
//			JourneyListDTO.self,
//			query: Query.queryItems(methods: [
//				.departureStopId(departureStopId: searchDepStop.id),
//				.arrivalStopId(arrivalStopId: searchArrStop.id),
//				.transfersCount(0),
//				.national(icTrains: false),
//				.nationalExpress(iceTrains: false),
//				.regionalExpress(reTrains: false),
//				.taxi(taxi: false),
//				.bus(bus: false),
//				.tram(tram: false),
//				.subway(uBahn: false),
//				.ferry(ferry: false),
//				.arrivalTime(arrivalTime: searchArrivalTime),
//			]),
//			type: ApiService.Requests.journeys
//		)
////		Task {
//			
//			
////			let cancellable = ApiService().fetch(JourneyListDTO.self,query: [
////				
////			], type: ApiService.Requests.journeys)
////			.sink(receiveCompletion: { _ in
////				print("compl")
////			}, receiveValue: { _ in
////				print("val")
////			})
//			
//			print(">>> ",journeyListDTO?.count)
//			let filtered = journeyListDTO?.filter({ journey in
//				guard jounrey.legs.count == 1,
//					  stop.departurePlatform.actual == searchArrivalPlatform,
//					  leg.lineViewData.type.rawValue == lineType.rawValue,
//					  leg.lineViewData.name == lineName
//				else {
//					return false
//				}
//				return true
//			})
//			
//			guard let filtered = filtered, 
//					filtered.count == 1,
//				  filtered.first?.legs.count == 1,
//				  let resultLeg = filtered.first?.legs.first
//			else {
//				return nil
//			}
//			
//			let resultTimeContainer = TimeContainer(
//				plannedDeparture: stop.time.iso.departure.planned,
//				plannedArrival: resultLeg.plannedArrival,
//				actualDeparture: stop.time.iso.departure.actual,
//				actualArrival: resultLeg.arrival,
//				cancelled: nil
//			)
//			
//			guard resultTimeContainer.date.arrival.actual != nil else {
//				return nil
//			}
//		
//			let newStop = StopViewData(
//				stopId: stop.id,
//				name: stop.name,
//				time: resultTimeContainer,
//				type: stop.stopOverType,
//				coordinates: stop.locationCoordinates
//			)
//			var newStops = leg.legStopsViewData
//			newStops.remove(at: 0)
//			newStops.insert(newStop, at: 0)
//			#warning("legDTO doesnt updated")
//			let newLeg = LegViewData(
//				isReachable: leg.isReachable,
//				legType: leg.legType,
//				tripId: leg.tripId,
//				direction: leg.direction,
//				legTopPosition: leg.legTopPosition,
//				legBottomPosition: leg.legBottomPosition,
//				remarks: leg.remarks,
//				legStopsViewData: newStops,
//				footDistance: leg.footDistance,
//				lineViewData: leg.lineViewData,
//				progressSegments: leg.progressSegments,
//				time: leg.time,
//				polyline: leg.polyline,
//				legDTO: leg.legDTO
//			)
//			var newLegs = jounrey.legs
//			newLegs.remove(at: 0)
//			newLegs.insert(newLeg, at: 0)
//			
//			newJourney = JourneyViewData(
//				journeyRef: jounrey.refreshToken,
//				badges: jounrey.badges,
//				sunEvents: jounrey.sunEvents,
//				legs: newLegs,
//				depStopName: jounrey.origin,
//				arrStopName: jounrey.destination,
//				time: jounrey.time,
//				updatedAt: jounrey.updatedAt,
//				remarks: jounrey.remarks
//			)
//		
//			return newJourney
////		}
//	}
	
	static func whenLoadingJourneyByRefreshToken() -> Feedback<State, Event> {
		Feedback { (state: State) -> AnyPublisher<Event, Never> in
			var token : String!
			var followID : Int64
			
			switch state.status {
			case let .loading(id, ref):
				token = ref
				followID = id
			default:
				return Empty().eraseToAnyPublisher()
			}
			
			guard let token = token else {
				return Just(Event.didFailedToLoadJourneyData(error: Error.inputValIsNil("journeyRef"))).eraseToAnyPublisher()
			}

			return Self.fetchJourneyByRefreshToken(
				ref: token,
				mode: .withoutPolylines
			)
				.mapError{ $0 }
				.asyncFlatMap{ data in
					
					let res = await data.journey.journeyViewDataAsync(
						depStop: state.data.depStop,
						arrStop: state.data.arrStop,
						realtimeDataUpdatedAt: Date.now.timeIntervalSince1970
					)
					
					guard let res = res else {
						return Event.didFailedToLoadJourneyData(error: Error.inputValIsNil("viewData"))
					}
					
					if Model.shared.journeyFollowViewModel.state.journeys.contains(where: {$0.id == followID}) == true {
						Model.shared.journeyFollowViewModel.send(event: .didRequestUpdateJourney(res, followID))
					}
					
					
//					if let arrivalTimeForTrain = Self.findingTrainArrivalTimeOrigin(
//						jounrey: res,
//						leg: res.legs[0]
//					) {
//						res = arrivalTimeForTrain
//					}
					return Event.didLoadJourneyData(data: res)
				}
				.catch {
					error in Just(.didFailedToLoadJourneyData(error: error as! (any ChewError)))
				}
				.eraseToAnyPublisher()
		}
	}
}
