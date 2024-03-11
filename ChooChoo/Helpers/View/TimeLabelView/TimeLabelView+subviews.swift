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
				Text(verbatim:  delay > 0 ? "+" + String(delay) : "")
					.chewTextSize(size.chewTextStyle)
					.lineLimit(1)
			case .big,.huge:
				if delay > 0 {
					if let time = time.planned {
						Text(time,style: .time)
							.strikethrough()
							.chewTextSize(.medium)
							.lineLimit(1)
					}
				} else {
					if let time = time.actual {
						Text(time,style: .time)
							.strikethrough()
							.chewTextSize(.medium)
							.lineLimit(1)
					}
				}
			}
		}
		.foregroundColor(.secondary)
	}
	func mainTime(delay : Int) -> some View {
		Group {
			switch delayStatus {
			case .cancelled:
				if let time = time.planned {
					Text(time, style: .time)
						.foregroundColor(Color.secondary)
						.strikethrough()
						.lineLimit(1)
				}
			default:
				if let time = time.actual {
					Text(time, style: .time)
						.foregroundColor(delay < 5 ? .primary : Color.chewFillRedPrimary)
						.lineLimit(1)
				}
			}
		}
		.chewTextSize(size.chewTextStyle)
	}
}

