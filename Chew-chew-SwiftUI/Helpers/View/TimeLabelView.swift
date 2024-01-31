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
	init(
		isSmall: Bool,
		arragement : Arragement,
		time : Prognosed<String>,
		delay: Int?,
		isCancelled : Bool
	) {
		self.delay = delay
		self.isSmall = isSmall
		self.arragement = arragement
		self.time = time
		self.isCancelled = isCancelled
	}
	
	init(
		stopOver : StopViewData,
		stopOverType : StopOverType
	) {
		self.delay = stopOver.stopOverType.timeLabelViewDelay(timeContainer: stopOver.timeContainer)
		self.isSmall = stopOverType.smallTimeLabel
		self.arragement = stopOverType.timeLabelArragament
		let time = stopOver.stopOverType.timeLabelViewTime(timeStringContainer: stopOver.timeContainer.stringTimeValue)
		self.time = Prognosed(actual: time.actual ?? "",planned: time.planned ?? "")
		self.isCancelled = stopOver.stopOverType.stopOverCancellationType(stopOver: stopOver) == .fullyCancelled
	}
	
	init(
		stopOver : StopViewData
	) {
		self.delay = stopOver.stopOverType.timeLabelViewDelay(timeContainer: stopOver.timeContainer)
		self.isSmall = stopOver.stopOverType.smallTimeLabel
		self.arragement = stopOver.stopOverType.timeLabelArragament
		let time = stopOver.stopOverType.timeLabelViewTime(timeStringContainer: stopOver.timeContainer.stringTimeValue)
		self.time = Prognosed(actual: time.actual ?? "",planned: time.planned ?? "")
		self.isCancelled = stopOver.stopOverType.stopOverCancellationType(stopOver: stopOver) == .fullyCancelled
	}
	
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
		Group {
			switch cancelled {
			case true:
				Text(time.planned)
					.foregroundColor(Color.chewRedScale80)
					.strikethrough()
					.chewTextSize(isSmall == false ? .big : .medium)
			case false:
				Text(delay < 1 ? time.planned : time.actual)
					.foregroundColor(delay < 5 ? isSmall ? .primary : .primary : Color.chewRedScale80)
					.chewTextSize(isSmall == false ? .big : .medium)
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
