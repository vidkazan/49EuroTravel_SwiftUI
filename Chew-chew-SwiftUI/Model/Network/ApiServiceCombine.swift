//
//  ApiService.swift
//  49EuroTravel
//
//  Created by Dmitrii Grigorev on 05.05.23.
//

import Foundation
import DequeModule
import Combine

extension ApiService  {
	static func fetchCombine<T : Decodable>(
		_ t : T.Type,
		query : [URLQueryItem],
		type : Requests,
		requestGroupId : String) -> AnyPublisher<T,ApiServiceError> {
			return Self.executeCombine(T.self, query: query, type: type)
	}
	
	
	static private func executeCombine<T: Decodable>(
		_ t : T.Type,
		query : [URLQueryItem],
		type : Requests
	) -> AnyPublisher<T, ApiServiceError> {
		guard let url = generateUrl(query: query, type: type) else {
			let subject = Future<T,ApiServiceError> { promise in
				return promise(.failure(.badUrl))
			}
			return subject.eraseToAnyPublisher()
		}
		let request = type.getRequest(urlEndPoint: url)
		return URLSession.shared
				.dataTaskPublisher(for: request)
				.tryMap { result -> T in
					let value = try JSONDecoder().decode(T.self, from: result.data)
					print("🟢 > api: done:",type,url)
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
