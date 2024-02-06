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
		Group {
			switch size {
			case .small,.medium:
				return Text(delay > 0 ? "+" + String(delay) : "")
					.chewTextSize(size.chewTextStyle)
					.lineLimit(1)
			case .big,.huge:
				return Text(delay > 0 ? (time.planned ?? "") : (time.actual ?? ""))
					.strikethrough()
					.chewTextSize(.medium)
					.lineLimit(1)
			}
		}
		.foregroundColor(.secondary)
	}
	func mainTime(delay : Int) -> some View {
		Group {
			switch delayStatus {
			case .cancelled:
				Text(time.planned ?? "")
					.foregroundColor(Color.secondary)
					.strikethrough()
					.lineLimit(1)
			default:
				Text(time.actual ?? "")
					.foregroundColor(delay < 5 ? .primary : Color.chewFillRedPrimary)
					.lineLimit(1)
			}
		}
		.chewTextSize(size.chewTextStyle)
	}
}

