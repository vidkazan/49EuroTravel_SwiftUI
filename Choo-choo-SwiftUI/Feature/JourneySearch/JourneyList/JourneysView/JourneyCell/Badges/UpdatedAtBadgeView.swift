//
//  UpdatedAtView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 16.02.24.
//

import Foundation
import SwiftUI

struct UpdatedAtBadgeView : View {
	let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
	let refTime : Double
	let bgColor : Color
	let isLoading : Bool
	@State var updatedAt : String
	
	init(bgColor : Color, refTime : Double, isLoading : Bool) {
		self.bgColor = bgColor
		self.refTime = refTime
		self.isLoading = isLoading
		self.updatedAt = Self.update(refTime)
	}
	
	var body : some View {
		HStack(spacing: 2) {
			Text(updatedAt)
				.lineLimit(1)
				.foregroundColor(.primary.opacity(0.6))
				.onAppear { self.updatedAt = Self.update(refTime) }
				.onReceive(timer, perform: { _ in
					self.updatedAt = Self.update(refTime)
				})
			if isLoading == true {
				ProgressView()
					.scaleEffect(0.65)
					.frame(width: 15, height: 15)
			}
		}
	}
	
	static func update(_ refTime : Double) -> String {
		let minutes = DateParcer.getTwoDateIntervalInMinutes(
			date1: Date(timeIntervalSince1970: .init(floatLiteral: refTime)),
			date2: .now)
		
		switch minutes {
		case .none:
			return "error"
		case .some(let wrapped):
			switch wrapped {
			case 0..<1:
				return "updated now"
			default:
				return "updated \(DateParcer.timeDuration(minutes) ?? "-") ago"
			}
		}
	}
}
