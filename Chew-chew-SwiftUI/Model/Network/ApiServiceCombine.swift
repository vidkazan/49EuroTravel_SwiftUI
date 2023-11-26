//
//  ApiService.swift
//  49EuroTravel
//
//  Created by Dmitrii Grigorev on 05.05.23.
//

import Foundation
import DequeModule
import Combine

protocol HTTPClient {
	func execute<T:Decodable>(_ t : T.Type,request: URLRequest, type : ApiService.Requests) -> AnyPublisher<T,ApiServiceError>
}

class MockClient : HTTPClient {
	
	var inputRequest: URLRequest?
	var executeCalled = false
	var requestType : ApiService.Requests?
	
	func execute<T: Decodable>(
		_ t : T.Type,
		request : URLRequest,
		type : ApiService.Requests
	) -> AnyPublisher<T, ApiServiceError> {
		executeCalled = true
		inputRequest = request
		requestType = type
		return Empty().eraseToAnyPublisher()
	}
}

class ApiClient : HTTPClient {
	func execute<T: Decodable>(
		_ t : T.Type,
		request : URLRequest,
		type : ApiService.Requests
	) -> AnyPublisher<T, ApiServiceError> {
		return URLSession.shared
			.dataTaskPublisher(for: request)
			.tryMap { data, response -> T in
				guard let response = response as? HTTPURLResponse else {
					throw ApiServiceError.cannotDecodeRawData
				}
				switch response.statusCode {
				case 500...599:
					throw ApiServiceError.badServerResponse(code: response.statusCode)
				case 400...499:
					throw ApiServiceError.badServerResponse(code: response.statusCode)
				default:
					break
				}
				let value = try JSONDecoder().decode(T.self, from: data)
				print("🟢 > api: done:",type.description, request.url ?? "")
				return value
			}
			.receive(on: DispatchQueue.main)
			.mapError{ error -> ApiServiceError in
				switch error {
				case let error as ApiServiceError:
					print("🔴> api: error:",type,request.url ?? "url",error)
					return error
				default:
					print("🔴> api: error:",type,request.url ?? "url",error)
					return .generic(error)
				}
			}
			.eraseToAnyPublisher()
	}
}

extension ApiService {
	func fetch<T: Decodable>(
		_ t : T.Type,
		query : [URLQueryItem],
		type : Requests
	) -> AnyPublisher<T, ApiServiceError> {
		
		guard let url = ApiService.generateUrl(query: query, type: type) else {
			return Future<T,ApiServiceError> {
				return $0(.failure(.badUrl))
			}.eraseToAnyPublisher()
		}
		
		let request = type.getRequest(urlEndPoint: url)
		return self.client.execute(t.self, request: request, type: type)
	}	
}
