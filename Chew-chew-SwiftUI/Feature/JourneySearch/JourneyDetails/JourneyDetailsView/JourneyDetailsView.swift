//
//  JourneyDetails.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.09.23.
//

import SwiftUI
import MapKit

extension JourneyDetailsView {
	enum SheetType : Equatable {
		case none
		case map(leg : LegViewData)
		case fullLeg(leg : LegViewData)
		
		var sheetIsPresented : Binding<Bool> {
			switch self {
			case .none:
				return .init(
					get: {
						return false
					},
					set: { bool in }
				)
			default:
				return .init(
					get: {
						return true
					},
					set: { bool in }
				)
			}
		}
	}
}
