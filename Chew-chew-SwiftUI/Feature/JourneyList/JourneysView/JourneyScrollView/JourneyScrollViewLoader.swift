//
//  JourneyScrollViewLoader.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 29.08.23.
//

import SwiftUI

struct JourneyListViewLoader: View {
	static let mockViewData = JourneyViewData(
		journeyRef: nil,
		badges: [],
		sunEvents: [],
		legs: [.init(
			isReachable: true,
			legType: .line,
			tripId: nil,
			direction: "",
			duration: "11111",
			legTopPosition: 0,
			legBottomPosition: 1,
			remarks: nil,
			legStopsViewData: [],
			footDistance: 0,
			lineViewData: .init(type: .national, name: "", shortName: ""),
			progressSegments: .init(segments: [], heightTotalCollapsed: 0, heightTotalExtended: 0),
			timeContainer: .init(),
			polyline: nil
		)],
		depStopName: nil,
		arrStopName: nil,
		time: .init(),
		updatedAt: 0
	)
	@State var count = 0
	let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
	var body: some View {
		VStack(spacing: 5) {
			ForEach(0...count,id: \.self) { index in
				JourneyCell(journey: Self.mockViewData)
					.redacted(reason: .placeholder)
					.transition(.move(edge: .top))
					.animation(.spring(response: 0.5), value: index)
			}
			Spacer()
		}
		.onReceive(timer, perform: { _ in
			if count < 2 { count+=1 }
		})
	}
}
