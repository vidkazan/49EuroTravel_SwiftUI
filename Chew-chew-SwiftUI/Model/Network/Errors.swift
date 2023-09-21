//
//  ApiServiceErrors.swift.swift
//  49EuroTravel
//
//  Created by Dmitrii Grigorev on 05.05.23.
//

import Foundation

struct CustomErrors : Error {
	let apiServiceErrors : ApiServiceError
	let source : ApiService.Requests
}

enum ApiServiceError : Error {
	case badUrl
	case cannotConnectToHost(String)
	case badServerResponse(code : Int)
	case cannotDecodeRawData
	case cannotDecodeContentData
//	case unauthorised
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
//		case .unauthorised:
//			return "Your token is expired"
		case .badRequest:
			return "Bad search request"
		case .requestRateExceeded:
			return "Request rate exceeded"
		case .generic(let error):
			return error.localizedDescription
		case .stopNotFound:
			return "stop not found"
		case .connectionNotFound:
			return "connection not found"
		case .failedToGetUserLocation:
			return "failedToGetUserLocation"
		}
	}
}
