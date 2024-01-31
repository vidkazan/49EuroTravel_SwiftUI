//
//  SunEventsGradient.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 31.01.24.
//

import Foundation
import SwiftUI

struct SunEventsGradient : View {
	let gradientStops : [Gradient.Stop]
	let size : CGSize
	let isProgressLine : Bool
	let progressLineProportion : Double
	var body: some View {
		switch isProgressLine {
		case true:
			RoundedRectangle(cornerRadius: 5)
				.fill(Color.chewFillGreenPrimary.opacity(0.95))
				.frame(
					width: size.width * progressLineProportion,
					height: 26
				)
				.position(
					x : size.width * progressLineProportion / 2,
					y : size.height/2
				)
				.cornerRadius(5)
		case false:
			RoundedRectangle(cornerRadius: 5)
				.fill(.gray)
				.overlay{
					LinearGradient(
						stops: gradientStops,
						startPoint: UnitPoint(x: 0, y: 0),
						endPoint: UnitPoint(x: 1, y: 0))
				}
				.frame(
					maxWidth: size.width > 0 ? size.width - 1 : 0 ,
					maxHeight: 26
				)
				.cornerRadius(5)
		}
	}
}
