//
//  RemarkViewData.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.02.24.
//

import Foundation
import SwiftUI

struct RemarkViewData : Equatable, Hashable {
	let type : RemarkType
	let summary : String
	let text : String
}

extension RemarkViewData {
	enum RemarkType : String {
		case status
		case hint
		
		var priority : Int {
			switch self {
			case .status:
				return 0
			case .hint:
				return 1
			}
		}
		
		var symbol : ChooSFSymbols {
			switch self {
			case .status:
				return .boltFill
			case .hint:
				return .infoCircle
			}
		}
		
		var color : Color {
			switch self {
			case .status:
				return .chewFillRedPrimary
			case .hint:
				return .primary.opacity(0.8)
			}
		}
	}
}
