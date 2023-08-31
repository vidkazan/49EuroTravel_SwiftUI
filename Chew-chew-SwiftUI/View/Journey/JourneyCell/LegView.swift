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
				.foregroundColor(Color(uiColor: leg.color))
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
