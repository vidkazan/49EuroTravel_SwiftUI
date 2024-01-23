//
//  SearchJourneyVM+ConstructJourneyData.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 07.09.23.
//

import Foundation
import CoreLocation

func constructStopFromStopDTO(data : StopDTO?) -> Stop? {
	guard let data = data,
		  let typeDTO = data.type  else { return nil }
	let type : LocationType = {
		switch typeDTO {
		case "stop":
			return .stop
		case "location":
			return .pointOfInterest
		default:
			return .location
		}
	}()
	return Stop(
		coordinates: CLLocationCoordinate2D(
			latitude: data.latitude ?? data.location?.latitude ?? 0 ,
			longitude: data.longitude ?? data.location?.longitude ?? 0
		),
		type: type,
		stopDTO: data
	)
}

func constructJourneyListViewDataAsync(journeysData : JourneyListDTO, depStop : Stop, arrStop : Stop) async -> [JourneyViewData] {
	return constructJourneyListViewData(journeysData: journeysData, depStop: depStop, arrStop: arrStop)
}

func constructJourneyListViewData(journeysData : JourneyListDTO, depStop : Stop, arrStop : Stop)  -> [JourneyViewData] {
	guard let journeys = journeysData.journeys else { return [] }
	var res = [JourneyViewData]()
	
	for j in journeys {
		res.append( constructJourneyViewData(
			journey: j,
			depStop: depStop,
			arrStop: arrStop,
			realtimeDataUpdatedAt: Double(journeysData.realtimeDataUpdatedAt ?? 0)
		))
	}
	return res
}
