//
//  Location.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 13.10.23.
//

import Foundation

protocol ChewLocation {
	var coordinates : LocationCoordinates { get }
	var type : LocationType { get }
}
