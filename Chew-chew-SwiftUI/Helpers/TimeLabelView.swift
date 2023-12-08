//
//  TimeLabelView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 20.09.23.
//

import Foundation
import SwiftUI

// TODO: tests
struct TimeLabelView: View {
	enum Arragement {
		case left
		case right
		case top
		case bottom
	}
	let isSmall : Bool
	let arragement : Arragement
	var delay : Int?
	var time : PrognosedTime<String>
	var isCancelled : Bool
	init(
		isSmall: Bool,
		arragement : Arragement,
		time : PrognosedTime<String>,
		delay: Int?,
		isCancelled : Bool
	) {
		self.delay = delay
		self.isSmall = isSmall
		self.arragement = arragement
		self.time = time
		self.isCancelled = isCancelled
	}
	
	var body: some View {
		switch isCancelled {
		case true:
			mainTime(delay: 0, cancelled: true)
				.padding(4)
		case false:
			switch delay {
			case .none:
				mainTime(delay: 0, cancelled: false)
					.padding(4)
			case .some(let delay):
				switch delay {
				case 0:
					mainTime(delay: 0, cancelled: false)
						.padding(4)
				default:
					switch arragement {
					case .left,.right:
						HStack(spacing: 2){
							switch arragement == .left {
							case true:
								optionalTime(delay: delay)
								mainTime(delay: delay, cancelled: false)
							case false:
								mainTime(delay: delay, cancelled: false)
								optionalTime(delay: delay)
							}
						}
						.padding(4)
					case .bottom,.top:
						VStack(spacing: 2){
							switch arragement == .top {
							case true:
								optionalTime(delay: delay)
								mainTime(delay: delay, cancelled: false)
							case false:
								mainTime(delay: delay, cancelled: false)
								optionalTime(delay: delay)
							}
						}
						.padding(4)
						.padding(.horizontal, 2)
					}
				}
			}
		}
		
		
//		switch delay {
//		case .onTime:
//			mainTime(delay: 0, cancelled: false)
//				.padding(4)
//		case .delay(let delay):
//
//		case .cancelled:
//
//		}
	}
}

extension TimeLabelView {
	func optionalTime(delay : Int) -> some View {
		switch isSmall {
		case true:
			return Text(delay > 0 ? "+" + String(delay) : "")
				.foregroundColor(isSmall ? .gray : .secondary)
				.chewTextSize(.medium)
		case false:
			return Text(delay > 0 ? time.planned : time.actual)
				.strikethrough()
				.foregroundColor(isSmall ? .gray : .secondary)
				.chewTextSize(.medium)
		}
	}
	func mainTime(delay : Int, cancelled : Bool) -> some View {
		if cancelled == true {
			return	Text(time.planned)
				.foregroundColor(Color.chewRedScale80)
				.font(
					.system(
						size: isSmall == false ? 17 : 12,
						weight: isSmall == false ? .semibold : .medium
					)
				)
				.strikethrough()
		} else {
			return	Text(delay < 1 ? time.planned : time.actual)
				.foregroundColor(
					delay < 5 ? isSmall ? .primary : .primary : Color.chewRedScale80
				)
				.font(
					.system(
						size: isSmall == false ? 17 : 12,
						weight: isSmall == false ? .semibold : .medium
					)
				)
		}
	}
}
