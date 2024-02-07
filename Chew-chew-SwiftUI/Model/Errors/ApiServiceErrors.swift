//
//  ApiServiceErrors.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 22.01.24.
//

import Foundation

	enum ApiServiceError : ChewError {
		static func == (lhs: ApiServiceError, rhs: ApiServiceError) -> Bool {
			return lhs.description == rhs.description
		}
		
		func hash(into hasher: inout Hasher) {
			switch self {
			case .badUrl:
				break
			case .cannotConnectToHost(let string):
				hasher.combine(string)
			case .badServerResponse(let code):
				hasher.combine(code)
			case .cannotDecodeRawData:
				break
			case .cannotDecodeContentData:
				break
			case .badRequest:
				break
			case .requestRateExceeded:
				break
			case .generic(let error):
				hasher.combine(error.localizedDescription)
			case .stopNotFound:
				break
			case .connectionNotFound:
				break
			case .failedToGetUserLocation:
				break
			}
		}
		case badUrl
		case cannotConnectToHost(String)
		case badServerResponse(code : Int)
		case cannotDecodeRawData
		case cannotDecodeContentData
		case badRequest
		case requestRateExceeded
		case generic(Error)
		case stopNotFound
		case connectionNotFound
		case failedToGetUserLocation
		
		var description : String  {
			switch self {
			case .badUrl:
				return "Bad url"
			case .cannotConnectToHost(let string):
				return string
			case .badServerResponse(let code):
				return "Bad server response \(code)"
			case .cannotDecodeRawData:
				return "Server response data nil"
			case .cannotDecodeContentData:
				return "Server response data decoding"
			case .badRequest:
				return "Bad search request"
			case .requestRateExceeded:
				return "Request rate exceeded"
			case .generic(let error):
				return error.localizedDescription
			case .stopNotFound:
				return "Stop not found"
			case .connectionNotFound:
				return "Connection not found"
			case .failedToGetUserLocation:
				return "Failed to get user location"
			}
		}
	}
