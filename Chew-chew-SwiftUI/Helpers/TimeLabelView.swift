//
//  TimeLabelView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 20.09.23.
//

import Foundation
import SwiftUI

struct TimeLabelView: View {
	enum Arragement {
		case left
		case right
		case top
		case bottom
	}
	let isSmall : Bool
	let arragement : Arragement
	var planned : String
	var actual : String
	
	init(isSmall: Bool, arragement : Arragement, planned: String, actual: String) {
		self.isSmall = isSmall
		self.arragement = arragement
		self.planned = planned
		self.actual = actual
	}
	
	var body: some View {
		switch arragement {
		case .left,.right:
			HStack(spacing: 2){
				switch arragement == .left {
				case true:
					if !isSmall, actual != planned {
						actualTime(actual: actual)
					}
					plannedTime()
				case false:
					plannedTime()
					if !isSmall, actual != planned {
						actualTime(actual: actual)
					}
				}
			}
		case .bottom,.top:
			VStack(spacing: 2){
				switch arragement == .top {
				case true:
					if !isSmall, actual != planned {
						actualTime(actual: actual)
					}
					plannedTime()
				case false:
					plannedTime()
					if !isSmall, actual != planned {
						actualTime(actual: actual)
					}
				}
			}
		}
	}
}

extension TimeLabelView {
	func actualTime(actual : String) -> some View {
		Text(actual)
			.strikethrough()
			.foregroundColor(.secondary)
			.font(.system(size: 12,weight: .semibold))
	}
	func plannedTime() -> some View {
		Text(actual == planned ? planned : actual)
			.foregroundColor(
				actual == planned ? .primary.opacity(0.85) : Color(hue: 0, saturation: 1, brightness: 0.8))
			.font(.system(size: isSmall == false ? 17 : 12,weight: isSmall == false ? .semibold : .regular))
	}
}
