//
//  ApiServiceErrors.swift.swift
//  49EuroTravel
//
//  Created by Dmitrii Grigorev on 05.05.23.
//

import Foundation

struct CustomErrors : Error {
	let apiServiceErrors : any ChewError
	let source : ApiService.Requests
}

protocol ChewError : Error, Equatable, Hashable {
	var description : String { get }
}
