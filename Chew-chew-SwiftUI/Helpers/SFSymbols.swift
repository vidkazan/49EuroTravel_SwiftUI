//
//  SFSymbols.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 30.01.24.
//

import Foundation
import SwiftUI

enum ChewSFSymbols : String {
	case gearshape = "gearshape"
	case bookmark = "bookmark"
	case bookmarkFill = "bookmark.fill"
	case arrowClockwise = "arrow.clockwise"
	case exclamationmarkCircle = "exclamationmark.circle"
	case xmarkCircle = "xmark.circle"
	case location = "location"
	case locationFill = "location.fill"
	case arrowUpArrowDown = "arrow.up.arrow.down"
	case clockArrowCirclepath = "clock.arrow.circlepath"
	case chevronDownCircle = "chevron.down.circle"
	case figureWalkCircle = "figure.walk.circle"
	case arrowTriangle2Circlepath = "arrow.triangle.2.circlepath"
 
	
	case trainSideFrontCar = "train.side.front.car"
	case building2CropCircle = "building.2.crop.circle"
	case building2CropCircleFill = "building.2.crop.circle.fill"
	
	var fill : Self {
		switch self {
		case .gearshape:
			return self
		case .bookmark:
			return Self.bookmarkFill
		case .bookmarkFill:
			return self
		case .location:
			return Self.locationFill
		case .building2CropCircle:
			return Self.building2CropCircleFill
		default:
			return self
		}
	}
}

extension Image {
	init(_ chewSFSymbol : ChewSFSymbols) {
		self.init(systemName: chewSFSymbol.rawValue)
	}
}
