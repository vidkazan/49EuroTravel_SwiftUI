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
			}
		}
		
		var method : String {
			switch self {
			case .locations, .customGet, .journeys,.journeyByRefreshToken:
				return "GET"
			}
		}
		
		var headers : [(value : String, key : String)] {
			switch self {
			case .customGet, .locations, .journeys,.journeyByRefreshToken:
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
			}
		}
		
		func getRequest(urlEndPoint : URL) -> URLRequest {
			switch self {
			case .customGet, .locations,.journeys,.journeyByRefreshToken:
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
	
	
	static func fetch<T : Decodable>(
		_ t : T.Type,
		query : [URLQueryItem],
		type : Requests,
		requestGroupId : String,
		completed: @escaping (Result<T, ApiServiceError>) -> Void) {
		switch type {
		case .customGet:
			queue.async {
				execute(
					T.self,
					query: query,
					type: type,
					completed: completed
				)
			}
		default:
			switch type {
			case .locations:
				currentRequestGroupId = requestGroupId
				break
			default:
				break
			}
			fetchLobbyDeque.append((
				(type.description, requestGroupId),
				{
					execute(
					T.self,
					query: query,
					type: type,
					completed: completed
				)
			}))
			DispatchQueue.main.async {
				queue.async {
					while !fetchLobbyDeque.isEmpty {
						let task = self.fetchLobbyDeque.popFirst()
						switch type {
						case .locations,.journeys,.journeyByRefreshToken:
							if let t = set[type.index].1 {
//							//	prints("previous is cancelled")
								t.cancel()
							}
						case .customGet:
							break
						}
						switch type {
						case .locations, .journeys,.journeyByRefreshToken:
							if fetchLobbyDeque.contains(where: { $0.0.type == task?.0.type }) {
								print(task?.0.type.description ?? "", task?.0.query ?? "", "DROPPED by type")
							} else {
								task?.function()
							}
							return
						case .customGet:
							task?.function()
							print(task?.0.type.description ?? "", task?.0.query ?? "")
						}
					}
				}
			}
		}
	}

	
	static private func execute<T : Decodable>(
		_ t : T.Type,
		query : [URLQueryItem],
		type : Requests,
		completed: @escaping (Result<T, ApiServiceError>) -> Void
	) {
		let session = generateSession()
		guard let url = generateUrl(query: query, type: type) else {
			completed(.failure(.badUrl))
			print(">",Date.now.timeIntervalSince1970,type.description ,query)
			set[type.index].1 = nil
			return
		}
		let request = type.getRequest(urlEndPoint: url)
		let task = session.dataTask(with: request) { data, response, error in
			DispatchQueue.main.async {
				if let error = error as? URLError {
					switch error.code.rawValue  {
					case -999:
						break
					default:
						completed(.failure(.cannotConnectToHost(error.localizedDescription)))
					}
					print(">",Date.now.timeIntervalSince1970,type.description,query,"error Connect to HOST")
					set[type.index].1 = nil
					return
				}
				
				guard let response = response as? HTTPURLResponse  else {
					completed(.failure(.cannotDecodeRawData))
					print(">",Date.now.timeIntervalSince1970,type.description,query,"error Bad Response")
					set[type.index].1 = nil
					return
				}
				
				switch response.statusCode {
					case 400:
					completed(.failure(.badRequest))
						print(">",Date.now.timeIntervalSince1970,type.description,query,"error Bad Request")
						set[type.index].1 = nil
						return
					case 429:
					completed(.failure(.requestRateExceeded))
						print(">",Date.now.timeIntervalSince1970,type.description,query,"error Request Rate")
						set[type.index].1 = nil
						return
					case 200:
						break
					default:
						completed(.failure(.badServerResponse(code: response.statusCode)))
						print(">",Date.now.timeIntervalSince1970,type.description,query,"error Bad Response")
						set[type.index].1 = nil
						return
				}
				guard let data = data else {
					completed(.failure(.cannotDecodeRawData))
					print(">",Date.now.timeIntervalSince1970,type.description,query,"error Get Data")
					set[type.index].1 = nil
					return
				}
				switch type {
				case .locations,.journeys,.journeyByRefreshToken:
					let decoder = JSONDecoder()
					do {
						let decodedData = try decoder.decode(T.self, from: data)
						completed(.success(decodedData))
						set[type.index].1 = nil
						break
					} catch {
						completed(.failure(.cannotDecodeContentData))
						print(type.description,query,"error Decode JSON")
						set[type.index].1 = nil
						return
					}
				case .customGet:
					completed(.success(data as! T))
					set[type.index].1 = nil
				}
			}
		}
		
		switch type {
		case .locations,.journeys,.journeyByRefreshToken:
			set[type.index].1 = task
		case .customGet:
			break
		}
		task.resume()
		return
	}
	
	static func generateUrl(query : [URLQueryItem],
										type : Requests) -> URL? {
		let url : URL? = {
			switch type {
			case .locations,.journeys,.journeyByRefreshToken:
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
