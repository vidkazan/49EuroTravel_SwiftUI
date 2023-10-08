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
	var delay : TimeContainer.Status
	var planned : String
	var actual : String
	
	init(isSmall: Bool, arragement : Arragement, planned: String, actual: String, delay: TimeContainer.Status) {
		self.delay = delay
		self.isSmall = isSmall
		self.arragement = arragement
		self.planned = planned
		self.actual = actual
	}
	
	var body: some View {
		switch delay {
		case .onTime:
			mainTime(delay: 0, cancelled: false)
				.padding(4)
		case .delay(let delay):
			switch arragement {
			case .left,.right:
				HStack(spacing: 2){
					switch arragement == .left {
					case true:
						optionalTime(actual: actual, delay: delay)
						mainTime(delay: delay, cancelled: false)
					case false:
						mainTime(delay: delay, cancelled: false)
						optionalTime(actual: actual, delay: delay)
					}
				}
				.padding(4)
			case .bottom,.top:
				VStack(spacing: 2){
					switch arragement == .top {
					case true:
						optionalTime(actual: actual, delay: delay)
						mainTime(delay: delay, cancelled: false)
					case false:
						mainTime(delay: delay, cancelled: false)
						optionalTime(actual: actual, delay: delay)
					}
				}
				.padding(4)
				.padding(.horizontal, 2)
			}
		case .cancelled:
			mainTime(delay: 0, cancelled: true)
				.padding(4)
		}
	}
}

extension TimeLabelView {
	func optionalTime(actual : String,delay : Int) -> some View {
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
	func mainTime(delay : Int, cancelled : Bool) -> some View {
		if cancelled == true {
			return	Text(planned)
				.foregroundColor(Color.chewRedScale80)
				.font(.system(size: isSmall == false ? 17 : 12,weight: isSmall == false ? .semibold : .medium))
				.strikethrough()
		} else {
			return	Text(delay < 60 ? planned : actual)
				.foregroundColor(delay < 300 ? isSmall ? .gray : .primary.opacity(0.85) : Color.chewRedScale80)
				.font(.system(size: isSmall == false ? 17 : 12,weight: isSmall == false ? .semibold : .medium))
		}
	}
}
