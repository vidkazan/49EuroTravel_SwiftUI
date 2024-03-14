//
//  JourneyCell.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//

import Foundation
import SwiftUI

struct PlatformView: View {
	let isShowingPlatormWord : Bool
	let platform : Prognosed<String>
	var body: some View {
		if let pl = platform.actual {
			HStack(spacing: 2) {
				if isShowingPlatormWord == true {
					Text("platform",comment: "platformView")
						.chewTextSize(.medium)
						.foregroundColor(.primary.opacity(0.7))
				}
				Text(verbatim: pl)
					.lineLimit(1)
					.padding(3)
					.frame(minWidth: 20)
					.background(Color(red: 0.1255, green: 0.156, blue: 0.4))
					.foregroundColor(platform.actual == platform.planned ? .white : .red)
					.chewTextSize(.medium)
				
			}
		}
	}
}

