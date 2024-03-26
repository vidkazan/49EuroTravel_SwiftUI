//
//  StopListCell.swift
//  ChooChoo
//
//  Created by Dmitrii Grigorev on 13.03.24.
//

import Foundation
import SwiftUI

struct StopListCell : View {
	let stop : StopWithDistance
	
	init(stop: StopWithDistance) {
		self.stop = stop
	}
	
	init(stop: Stop) {
		self.stop = StopWithDistance(
			stop: stop,
			distance: nil
		)
	}
	var body: some View {
		Group {
			if let lineType = stop.stop.stopDTO?.products?.lineType,
				let icon = lineType.icon {
				Label {
					Text(verbatim: stop.stop.name)
						.lineLimit(1)
				} icon: {
					Image(icon)
						.padding(5)
						.frame(width: 30)
						.aspectRatio(1, contentMode: .fill)
						.badgeBackgroundStyle(BadgeBackgroundBaseStyle(lineType.color))
				}
			} else {
				Label(
					title: {
						Text(verbatim: stop.stop.name)
							.lineLimit(1)
					},
					icon: {
						Image(systemName: stop.stop.type.SFSIcon)
							.frame(width: 30)
					}
				)
			}
		}
		.padding(5)
		.chewTextSize(.big)
		.foregroundStyle(.primary)
		.frame(alignment: .leading)
	}
}

