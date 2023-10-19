//
//  ApiService.swift
//  49EuroTravel
//
//  Created by Dmitrii Grigorev on 05.05.23.
//

import Foundation
import DequeModule
import Combine


// TODO: remove api calls duplicates
class ApiService  {
	struct Response<T> {
		 let value: T
		 let response: URLResponse
	 }
	
	private static var set : [(Int, URLSessionDataTask?)] = (0 ..< 6).map { ($0,nil) }
	private static var currentRequestGroupId : String = ""
	private static var token : String =  ""
	private static let queue = DispatchQueue(label: "com.fcody.49euroTraveller.requestSerialQueue", qos: .utility)
	private static var fetchLobbyDeque = Deque<((type : String, query : String), function : (()->Void))>()
	
	enum Requests {
		case journeys
		case journeyByRefreshToken(ref : String)
		case locations(name : String)
		case trips(tripId : String)
		case customGet(path : String)
		
		var description : String {
			switch self {
			case .locations:
				return "locations"
			case .customGet:
				return "customGet"
			case .journeys:
				return "journeys"
			case .journeyByRefreshToken:
				return "journeyByRefreshToken"
			case .trips:
				return "trips"
			}
		}
		
		var index : Int {
			switch self {
			case .customGet:
				return 0
			case .locations:
				return 2
			case .journeys:
				return 3
			case .journeyByRefreshToken:
				return 4
			case .trips:
				return 5
			}
		}
		
		var method : String {
			switch self {
			case .locations, .customGet, .journeys,.journeyByRefreshToken,.trips:
				return "GET"
			}
		}
		
		var headers : [(value : String, key : String)] {
			switch self {
			case .customGet, .locations, .journeys,.journeyByRefreshToken,.trips:
				return []
			}
		}
		
		var urlString : String {
			switch self {
			case .journeys:
				return Constants.apiData.urlPathJourneys
			case .locations:
				return Constants.apiData.urlPathLocations
			case .customGet(let path):
				return path
			case .journeyByRefreshToken(let ref):
				return Constants.apiData.urlPathJourneys + "/" + ref
			case .trips(tripId: let tripId):
				return Constants.apiData.urlPathTrip + "/" + tripId
			}
		}
		
		func getRequest(urlEndPoint : URL) -> URLRequest {
			switch self {
			case .customGet, .locations,.journeys,.journeyByRefreshToken,.trips:
				var req = URLRequest(url : urlEndPoint)
				req.httpMethod = self.method
				for header in self.headers {
					req.addValue(header.value, forHTTPHeaderField: header.key)
				}
				return req
			}
		}
	}
	
	static func cancelAllOngoingRequests(){
		self.fetchLobbyDeque.removeAll()
	}
	
	static func generateUrl(query : [URLQueryItem],
										type : Requests) -> URL? {
		let url : URL? = {
			switch type {
			case .locations,.journeys,.journeyByRefreshToken,.trips:
				var components = URLComponents()
				components.path = type.urlString
				components.host = Constants.apiData.urlBase
				components.scheme = "https"
				components.queryItems = query
				return components.url
			case .customGet(let path):
				return URL(string: path)
			}
		}()
		return url
	}
	
	static func generateSession() -> URLSession {
		let sessionConfig = URLSessionConfiguration.default
		sessionConfig.timeoutIntervalForRequest = 5.0
		return URLSession(configuration: sessionConfig)
	}
}
