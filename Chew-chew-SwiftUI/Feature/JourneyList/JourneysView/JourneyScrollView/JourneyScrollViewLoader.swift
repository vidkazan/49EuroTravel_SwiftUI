//
//  JourneyScrollViewLoader.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 29.08.23.
//

import SwiftUI

struct JourneyScrollViewLoader: View {
	let viewData : JourneyViewData
	@State var count = 0
	let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
	var body: some View {
		VStack(spacing: 5) {
			ForEach(0...count,id: \.self) { index in
				JourneyCell(journey: viewData)
					.redacted(reason: .placeholder)
					.transition(.move(edge: .top))
					.animation(.spring(response: 0.5), value: index)
			}
			Spacer()
		}
		.onReceive(timer, perform: { _ in
			if count < 2 {
				count+=1
			}
		})
	}
}
