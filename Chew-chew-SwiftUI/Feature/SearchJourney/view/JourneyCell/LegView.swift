//
//  LegView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 25.08.23.
//

import SwiftUI

struct LegView: View {
    var leg : LegViewDataSourse
	let screenWidth = UIScreen.main.bounds.width
	
	init(leg: LegViewDataSourse) {
		self.leg = leg
	}
	
	var body: some View {
		GeometryReader { geo in
			Rectangle()
				.foregroundColor(leg.delayedAndNextIsNotReachable == true ? Color(hue: 0, saturation: 1, brightness: 0.6) : Color(hue: 0, saturation: 0, brightness: 0.3))
				.cornerRadius(8)
				.overlay() {
					if (Int(geo.size.width / 3) > leg.name.count) {
						Text(leg.name)
							.foregroundColor(.white)
							.font(.system(size: 12,weight: .semibold))
					} else {
						Text("")
					}
			}
		}
	}
}