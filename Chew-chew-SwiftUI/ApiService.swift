//
//  ApiService.swift
//  49EuroTravel
//
//  Created by Dmitrii Grigorev on 05.05.23.
//

import Foundation
import DequeModule

class ApiService  {
	private static var set : [(Int, URLSessionDataTask?)] = (0 ..< 6).map { ($0,nil) }
	private static var currentRequestGroupId : String = ""
	private static var token : String =  ""
	private static let queue = DispatchQueue(label: "com.fcody.49euroTraveller.requestSerialQueue", qos: .utility)
	private static var fetchLobbyDeque = Deque<((type : String, query : String), function : (()->Void))>()
	
	enum Requests {
		case journeys
		case locations(name : String)
//		case stopDepartures(stopId : Int)
		case customGet(path : String)
		
		var description : String {
			switch self {
			case .locations:
				return "locations"
			case .customGet:
				return "customGet"
			case .journeys:
				return "journeys"
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
			}
		}
		
		var method : String {
			switch self {
			case .locations, .customGet, .journeys:
				return "GET"
			}
		}
		
		var headers : [(value : String, key : String)] {
			switch self {
			case .customGet, .locations, .journeys:
				return []
			}
		}
		
		var urlString : String {
			switch self {
//			case .stopDepartures(let stopId):
//				return Constants.apiData.urlPathStops + String(stopId) + Constants.apiData.urlPathDepartures
			case .journeys:
				return Constants.apiData.urlPathJourneys
			case .locations:
				return Constants.apiData.urlPathLocations
			case .customGet(let path):
				return path
			}
		}
		
		func getRequest(urlEndPoint : URL) -> URLRequest {
			switch self {
			case .customGet, .locations,.journeys:
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
		completed: @escaping (Result<T, CustomErrors>) -> Void) {
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
						case .locations,.journeys:
							if let t = set[type.index].1 {
//							//	prints("previous is cancelled")
								t.cancel()
							}
						case .customGet:
							break
						}
						switch type {
						case .locations, .journeys:
							if fetchLobbyDeque.contains(where: { $0.0.type == task?.0.type }) {
								print(task?.0.type.description ?? "", task?.0.query ?? "", "DROPPED by type")
							} else {
								if !set.filter( { $0.1 != nil } ).isEmpty {
//									prints(task?.0.type.description ?? "", task?.0.query ?? "", "waiting")
//									usleep(100000)
								}
//								prints(task?.0.type.description ?? "", task?.0.query ?? "", "starting")
								task?.function()
//								prints(task?.0.type.description ?? "", task?.0.query ?? "")
							}
							return
//						case .getScaleTeamsAsCorrector, .getLocations:
//							if task?.0.query != currentRequestGroupId {
//								prints(task?.0.type.description ?? "", task?.0.query ?? "", "DROPPED by groupId")
//							} else {
//								prints(task?.0.type.description ?? "", task?.0.query ?? "", "waiting")
//								usleep(500000)
//								prints(task?.0.type.description ?? "", task?.0.query ?? "", "starting")
//								task?.function()
//								prints(task?.0.type.description ?? "", task?.0.query ?? "")
//							}
//							return
						case .customGet:
//							prints(task?.0.type.description ?? "", task?.0.query ?? "", "waiting")
//							usleep(100000)
//							prints(task?.0.type.description ?? "", task?.0.query ?? "", "starting")
							task?.function()
							print(task?.0.type.description ?? "", task?.0.query ?? "")
						}
					}
				}
			}
		}
	}
	
	static private func execute<T : Decodable>(_ t : T.Type,query : [URLQueryItem], type : Requests,completed: @escaping (Result<T, CustomErrors>) -> Void) {
		let sessionConfig = URLSessionConfiguration.default
		sessionConfig.timeoutIntervalForRequest = 10.0
		let session = URLSession(configuration: sessionConfig)
		
		let url : URL? = {
			switch type {
			case .locations,.journeys:
				var components = URLComponents()
				components.path = type.urlString
				components.host = Constants.apiData.urlBase
				components.scheme = "https"
				components.queryItems = query
//				prints(components)
				return components.url
			case .customGet(let path):
				return URL(string: path)
			}
		}()
		guard let url = url else {
			let error = CustomErrors(apiServiceErrors: .badUrl, source: type)
			completed(.failure(error))
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
						completed(.failure(CustomErrors(apiServiceErrors: .cannotConnectToHost(string: error.localizedDescription), source: type)))
					}
					print(">",Date.now.timeIntervalSince1970,type.description,query,"error Connect to HOST")
					set[type.index].1 = nil
					return
				}
				
				guard let response = response as? HTTPURLResponse  else {
					completed(.failure(CustomErrors(apiServiceErrors: .cannotDecodeRawData, source: type)))
					print(">",Date.now.timeIntervalSince1970,type.description,query,"error Bad Response")
					set[type.index].1 = nil
					return
				}
				
				switch response.statusCode {
//					case 401:
//						completed(.failure(.unauthorised))
//						print(">",Date.now.timeIntervalSince1970,type.description,query,"error Bad Response")
//						set[type.index].1 = nil
//						return
					case 400:
					completed(.failure(CustomErrors(apiServiceErrors: .badRequest, source: type)))
						print(">",Date.now.timeIntervalSince1970,type.description,query,"error Bad Response")
						set[type.index].1 = nil
						return
					case 429:
					completed(.failure(CustomErrors(apiServiceErrors: .requestRateExceeded, source: type)))
						print(">",Date.now.timeIntervalSince1970,type.description,query,"error Bad Response")
						set[type.index].1 = nil
						return
					case 200:
						break
					default:
					
						completed(.failure(CustomErrors(apiServiceErrors: .badServerResponse(code: response.statusCode), source: type)))
						print(">",Date.now.timeIntervalSince1970,type.description,query,"error Bad Response")
						set[type.index].1 = nil
						return
				}
				guard let data = data else {
					completed(.failure(CustomErrors(apiServiceErrors: .cannotDecodeRawData, source: type)))
					print(">",Date.now.timeIntervalSince1970,type.description,query,"error Get Data")
					set[type.index].1 = nil
					return
				}
				switch type {
				case .locations,.journeys:
					let decoder = JSONDecoder()
					do {
						let decodedData = try decoder.decode(T.self, from: data)
						completed(.success(decodedData))
//						prints(type.description,query,"finished")
						set[type.index].1 = nil
						break
					} catch {
						completed(.failure(CustomErrors(apiServiceErrors: .cannotDecodeContentData, source: type)))
//						print(type.description,query,"error Decode JSON")
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
		case .locations,.journeys:
			set[type.index].1 = task
		case .customGet:
			break
		}
		task.resume()
		return
	}
}
