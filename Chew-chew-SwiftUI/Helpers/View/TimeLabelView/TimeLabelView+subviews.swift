//
//  TimeLabelView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 20.09.23.
//

import Foundation
import SwiftUI


extension TimeLabelView {
	func optionalTime(delay : Int) -> some View {
		switch isSmall {
		case true:
			return Text(delay > 0 ? "+" + String(delay) : "")
				.foregroundColor(isSmall ? .gray : .secondary)
				.chewTextSize(.medium)
		case false:
			return Text(delay > 0 ? (time.planned ?? "") : (time.actual ?? ""))
				.strikethrough()
				.foregroundColor(isSmall ? .gray : .secondary)
				.chewTextSize(.medium)
		}
	}
	func mainTime(delay : Int, cancelled : Bool) -> some View {
		Group {
			switch cancelled {
			case true:
				Text(time.planned ?? "")
					.foregroundColor(Color.chewRedScale80)
					.strikethrough()
					.chewTextSize(isSmall == false ? .big : .medium)
			case false:
				Text(delay < 1 ? time.planned ?? "" : time.actual ?? "")
					.foregroundColor(delay < 5 ? isSmall ? .primary : .primary : Color.chewRedScale80)
					.chewTextSize(isSmall == false ? .big : .medium)
			}
		}
	}
}

