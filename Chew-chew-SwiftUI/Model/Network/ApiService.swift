//
//  ApiService.swift
//  49EuroTravel
//
//  Created by Dmitrii Grigorev on 05.05.23.
//

import Foundation
import DequeModule
import Combine

class ApiService  {
	let client : HTTPClient
	
	init(client : HTTPClient = ApiClient()) {
		self.client = client
	}
	
	enum Requests : Equatable {
		case journeys
		case journeyByRefreshToken(ref : String)
		case locations
		case trips(tripId : String)
		case generic(path : String)
		
		var description : String {
			switch self {
			case .locations:
				return "locations"
			case .generic:
				return "generic"
			case .journeys:
				return "journeys"
			case .journeyByRefreshToken:
				return "journeyByRefreshToken"
			case .trips:
				return "trips"
			}
		}
		
		var method : String {
			switch self {
			case .locations, .generic, .journeys,.journeyByRefreshToken,.trips:
				return "GET"
			}
		}
		
		var headers : [(value : String, key : String)] {
			switch self {
			case .generic, .locations, .journeys,.journeyByRefreshToken,.trips:
				return []
			}
		}
		
		var urlString : String {
			switch self {
			case .journeys:
				return Constants.apiData.urlPathJourneyList
			case .locations:
				return Constants.apiData.urlPathLocations
			case .generic(let path):
				return path
			case .journeyByRefreshToken(let ref):
				return Constants.apiData.urlPathJourneyList + "/" + ref
			case .trips(tripId: let tripId):
				return Constants.apiData.urlPathTrip + "/" + tripId
			}
		}
		
		func getRequest(urlEndPoint : URL) -> URLRequest {
			switch self {
			case .generic, .locations,.journeys,.journeyByRefreshToken,.trips:
				var req = URLRequest(url : urlEndPoint)
				req.httpMethod = self.method
				for header in self.headers {
					req.addValue(header.value, forHTTPHeaderField: header.key)
				}
				return req
			}
		}
	}

	static func generateUrl(query : [URLQueryItem], type : Requests) -> URL? {
		let url : URL? = {
			switch type {
			case .locations,.journeys,.journeyByRefreshToken,.trips:
				var components = URLComponents()
				components.path = type.urlString
				components.host = Constants.apiData.urlBase
				components.scheme = "https"
				components.queryItems = query
				return components.url
			case .generic(let path):
				return URL(string: path)
			}
		}()
		return url
	}
}

