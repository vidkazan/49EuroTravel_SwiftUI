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

func constructJourneysViewDataAsync(journeysData : JourneysContainer, depStop : Stop, arrStop : Stop) async -> [JourneyViewData] {
	guard let journeys = journeysData.journeys else { return [] }
	var res = [JourneyViewData]()
	
	for j in journeys {
		res.append( await constructJourneyViewDataAsync(
			journey: j,
			depStop: depStop,
			arrStop: arrStop
		))
	}
	return res
}
