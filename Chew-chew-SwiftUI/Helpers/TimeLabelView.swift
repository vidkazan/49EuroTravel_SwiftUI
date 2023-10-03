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
	var delay : Int
	var planned : String
	var actual : String
	
	init(isSmall: Bool, arragement : Arragement, planned: String, actual: String, delay: Int) {
		self.delay = delay
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
					if delay > 59 {
						optionalTime(actual: actual)
					}
					mainTime()
				case false:
					mainTime()
					if delay > 59 {
						optionalTime(actual: actual)
					}
				}
			}
			.padding(3)
		case .bottom,.top:
			VStack(spacing: 2){
				switch arragement == .top {
				case true:
					if delay > 59 {
						optionalTime(actual: actual)
					}
					mainTime()
				case false:
					mainTime()
					if delay > 59 {
						optionalTime(actual: actual)
					}
				}
			}
			.padding(3)
		}
	}
}

extension TimeLabelView {
	func optionalTime(actual : String) -> some View {
		switch isSmall {
		case true:
			return Text(delay >= 60 ? "+" + String(delay/60) : "")
				.foregroundColor(isSmall ? .gray : .secondary)
				.font(.system(size: 12,weight: .semibold))
		case false:
			return Text(delay >= 60 ? planned : actual)
				.strikethrough()
				.foregroundColor(isSmall ? .gray : .secondary)
				.font(.system(size: 12,weight: .semibold))
		}
	}
	func mainTime() -> some View {
		Text(delay < 60 ? planned : actual)
			.foregroundColor(
				delay < 300 ? isSmall ? .gray : .primary.opacity(0.85) : Color(hue: 0, saturation: 1, brightness: 0.8))
			.font(.system(size: isSmall == false ? 17 : 12,weight: isSmall == false ? .semibold : .medium))
	}
}
