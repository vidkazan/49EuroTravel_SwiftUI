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
	var time : Prognosed<String>
	var isCancelled : Bool
	
	
	var body: some View {
		switch isCancelled {
		case true:
			mainTime(delay: 0, cancelled: true)
				.padding(2)
		case false:
			switch delay {
			case .none:
				mainTime(delay: 0, cancelled: false)
					.padding(2)
			case .some(let delay):
				switch delay {
				case 0:
					mainTime(delay: 0, cancelled: false)
						.padding(2)
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
						.padding(2)
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
						.padding(2)
					}
				}
			}
		}
	}
}


struct TimeLabelPreviews: PreviewProvider {
	static var previews: some View {
		VStack {
			TimeLabelView(
				isSmall: false,
				arragement: .bottom,
				time: .init(actual: "00:00", planned: "00:00"),
				delay: 0,
				isCancelled: false
			)
			.background(Color.chewFillSecondary)
			.cornerRadius(8)
			TimeLabelView(
				isSmall: false,
				arragement: .bottom,
				time: .init(actual: "00:00", planned: "00:00"),
				delay: 61,
				isCancelled: false
			)
			.background(Color.chewFillSecondary)
			.cornerRadius(8)
		}
	}
}
