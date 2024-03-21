//
//  Settings.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 25.10.23.
//

import Foundation
import SwiftUI

struct Settings : Equatable,Hashable {
	// api settings
	let customTransferModes : Set<LineType>
	let transportMode : TransportMode
	let transferTime : TransferTime
	let transferCount : TransferCountCases
	let accessiblity : Accessiblity
	let walkingSpeed : WalkingSpeed
	let language : Language
	let startWithWalking : Bool
	let withBicycle : Bool
	// app settings
	let onboarding : Bool
	let debugSettings : ChewDebugSettings
	let legViewMode : LegViewMode
	var iconBadge : IconBadge {
		get {
			if !isDefault() {
				return .redDot
			}
			if transportMode == .regional {
				return .regional
			}
			if transportMode == .custom, customTransferModes.count < 7 {
				return .redDot
			}
			return .empty
		}
	}
}

extension Settings {
	func isDefault() -> Bool {
		guard transferTime == transferTime.defaultValue else {
			return false
		}
		guard transferCount == transferCount.defaultValue else {
			return false
		}
		guard accessiblity == accessiblity.defaultValue else {
			return false
		}
		guard startWithWalking == true else {
			return false
		}
		guard withBicycle == false else {
			return false
		}
		return true
	}
}

extension Settings {
	enum IconBadge {
		case empty
		case regional
		case redDot
		
		@ViewBuilder var view : some View {
			Group {
				switch self {
				case .empty:
					EmptyView()
				case .regional:
					Circle()
						.fill(Color.chewFillTertiary)
						.frame(width: 14,height: 14)
						.overlay {
							Image("re")
								.chewTextSize(.small)
								.tint(.primary)
						}
				case .redDot:
					Circle()
						.fill(Color.chewFillRedPrimary)
						.frame(width: 14,height: 14)
				}
			}
		}
	}

}
