//
//  ApiServiceErrors.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 22.01.24.
//

import Foundation

	enum ApiError : ChewError {
		static func == (lhs: ApiError, rhs: ApiError) -> Bool {
			return lhs.description == rhs.description
		}
		
		func hash(into hasher: inout Hasher) {
			switch self {
			case .generic:
				break
			case .hafasError(let error):
				hasher.combine(error.hafasCode)
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
			case .stopNotFound:
				break
			case .connectionNotFound:
				break
			case .failedToGetUserLocation:
				break
			}
		}
		case hafasError(_ hafasError : HafasErrorDTO)
		case badUrl
		case cannotConnectToHost(String)
		case badServerResponse(code : Int)
		case cannotDecodeRawData
		case cannotDecodeContentData
		case badRequest
		case requestRateExceeded
		case stopNotFound
		case connectionNotFound
		case failedToGetUserLocation
		case generic(description : String)
		
		var description : String  {
			switch self {
			case .generic(let description):
				return description
			case .hafasError(let error):
				return error.hafasDescription ?? error.hafasMessage ?? error.message ?? NSLocalizedString("Unknown hafas error", comment: "ApiError")
			case .badUrl:
				return NSLocalizedString(
					"Bad url",
					comment: "ApiError"
				)
			case .cannotConnectToHost(let string):
				return string
			case .badServerResponse(let code):
				return NSLocalizedString(
					"Bad server response \(code)",
					comment: "ApiError"
				)
			case .cannotDecodeRawData:
				return NSLocalizedString(
					"Server response data nil",
					comment: "ApiError"
				)
			case .cannotDecodeContentData:
				return NSLocalizedString(
					"Server response data decoding",
					comment: "ApiError"
				)
			case .badRequest:
				return NSLocalizedString(
					"Bad search request",
					comment: "ApiError"
				)
			case .requestRateExceeded:
				return NSLocalizedString(
					"Request rate exceeded",
					comment: "ApiError"
				)
			case .stopNotFound:
				return NSLocalizedString(
					"Stop not found",
					comment: "ApiError"
				)
			case .connectionNotFound:
				return NSLocalizedString(
					"Connection not found",
					comment: "ApiError"
				)
			case .failedToGetUserLocation:
				return NSLocalizedString(
					"Failed to get user location",
					comment: "ApiError"
				)
			}
		}
	}
