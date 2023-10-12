//
//  Publisher+AsyncMap.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 12.10.23.
//

import Foundation
import Combine

extension Publisher {
//	func asyncFlatMap<T>(
//		   _ transform: @escaping (Output) async -> T
//	   ) -> Publishers.FlatMap<Future<T, Never>, Self> {
//		   flatMap { value in
//			   Future { promise in
//				   Task {
//					   let output = await transform(value)
//					   promise(.success(output))
//				   }
//			   }
//		   }
//	   }
	func asyncFlatMap<T>(_ transform: @escaping (Output) async throws -> T ) -> Publishers.FlatMap<Future<T,Error>,Self> {
		flatMap { value in
			Future { promise in
				Task {
					do {
						let output = try await transform(value)
						promise(.success(output))
					} catch {
						promise(.failure(error))
					}
				}
			}
		}
	}
}
